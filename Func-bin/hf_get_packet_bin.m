% ***********************************
% *** 20231007   Y Kasaba
% ***********************************
function [ret, st_ctl] = hf_get_packet_bin(in_file)

    % Input file
    r = fopen(in_file,'r');

    out_sz = 0;
    n_pkt = 0;
    ret = 0;

    while ~feof(r)
        % ----------------------
        % 20230917: Read binary header 10B = "RPWI"(4B) + "SID"(1B) + "AUX-size"(1B) + "HEADER-SIZE(1B) + "SCIENCE-size"(3B)
        % ----------------------
        hdr_bin = fread(r, 10, 'uint8');
        if size(hdr_bin) ~= 10
            break;
        end
        n_pkt = n_pkt + 1;

        st_bin = hf_get_hdr_bin(hdr_bin, n_pkt);
        if st_bin.err ~= 0
            fprintf("Packet error: invalid BIN packet header\n");
            ret = -1;
            break;
        end

        % data size
        sz = st_bin.pkt_len; 
        
        %----------------------------------------
        % Check HF science data or not
        %----------------------------------------
        ret=1;
        buff = fread(r,sz);        
    end
        
    fclose(r);

    st_ctl.n_pkt  = n_pkt;
    st_ctl.out_sz = out_sz;

end
