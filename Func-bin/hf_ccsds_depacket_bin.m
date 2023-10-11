% ***********************************
% *** 20231008   Y Kasaba
% ***********************************
function [st_ctl, st_rpw, st_aux, st_hfa, st_time, rdata, data_sz, err] = hf_ccsds_depacket_bin(st_ctl)

    % reset values
    rdata   = [];
    data_sz = 0;
    st_aux  = 0;
    st_hfa  = 0;
    st_time = 0;
    err     = 1;
    st_rpw.sid = 0;
    
    while true
        % ----------------------
        % Read binary header 10B = "RPWI"(4B) + "SID"(1B) + "AUX-size"(1B) + "HEADER-SIZE(1B) + "SCIENCE-size"(3B)
        % ----------------------
        hdr_bin = fread(st_ctl.r, 10, 'uint8');
        if size(hdr_bin) ~= 10
            break;
        end
        err = 0;
        st_bin = hf_get_hdr_bin(hdr_bin, 0xff);
        sz     = st_bin.pkt_len;

        %----------------------------------------
        % Dummy ccsds header (6+10 Bytes)
        %----------------------------------------
        % st_pre = hf_get_hdr_pre(hdr_bin);
            
        % st_sec = hf_get_hdr_sec(hdr_bin);
        st_sec.time         = 0;    % dummy

        %----------------------------------------
        % Dummy RPWI header (8 Bytes)
        %----------------------------------------
        %st_rpw = hf_get_hdr_rpw(hdr_bin);
        st_rpw.aux_len    = st_bin.size_aux;
        if st_bin.sid < 0x10
            st_rpw.sid = st_bin.sid + 0x40;
        else
            st_rpw.sid = st_bin.sid + 0x60;
        end
        st_rpw.delta_time = 0;      % dummy
        
        %----------------------------------------
        % Read Auxilary data
        %----------------------------------------
        % SW version
        if st_rpw.aux_len == 4
            st_ctl.ver = 1.0;
        else
            st_ctl.ver = 2.0;
        end
        fprintf("\n<< SW-ver:%d  Aux-len:%d >>\n", st_ctl.ver, st_rpw.aux_len);

        % read AUX field
        aux = cast(fread(st_ctl.r,st_rpw.aux_len),'uint8');
        st_aux = hf_get_aux(aux, st_rpw.sid, st_ctl);
        ret = hf_print_aux(st_rpw.sid, st_aux, st_ctl);
        sz = sz - st_rpw.aux_len;

        % number of available channel
        st_ctl.n_ch = st_aux.xch_sel + st_aux.ych_sel + st_aux.zch_sel;

        %----------------------------------------
        % Read HF header
        %----------------------------------------
        % set HF header length
        if st_ctl.ver == 1.0 
            hf_hdr_len = 24;
        else
            % if st_aux.sweep_table_id == 0xFF || st_aux.sweep_table_id == 0x1F
            hf_hdr_len = st_aux.hf_hdr_len;
            % else
            % hf_hdr_len = 0;
            % end
        end
        fprintf("\tHF header len : %d\n",hf_hdr_len);
            
        % read HF header
        if hf_hdr_len ~= 0
            hdr_hf = fread(st_ctl.r,hf_hdr_len,'uint8');
            st_hfa = hf_get_hdr_hf(hdr_hf, hf_hdr_len, st_ctl.ver);
            sz = sz - double(hf_hdr_len);
            ret = hf_print_hf(st_hfa, st_ctl);
        else
            st_hfa.exist = 0;
        end
            
        if st_ctl.ver == 1.0 
            % add fixed AUX field & HF header for Ver1 SW 
            [st_aux, st_hfa] = hf_add_hdr_ver1(st_aux, st_hfa, st_rpw, st_ctl);
        end

        %----------------------------------------
        % Get time information (added to hdr_rpw)
        %----------------------------------------
        [st_time, st_ctl] = hf_get_time_info(st_ctl, st_sec, st_rpw);


        %----------------------------------------
        % Read HF data
        %----------------------------------------
        buff = fread(st_ctl.r,sz);
        rdata = vertcat(rdata, buff);
        data_sz = data_sz + sz;

        %----------------------------------------
        % Exit
        %----------------------------------------
        break;

    end

end
