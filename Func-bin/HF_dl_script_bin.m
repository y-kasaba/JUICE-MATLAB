% ***********************************
% *** 20231007   Y Kasaba
% ***********************************
% ex)   input_file = 'C:\share\Linux\doc\juice\ccsds\system_test\20210531_SCPFM_PTR_RPWI_2\20210531_SCPFM_PTR_RPWI_2_day3_xid32770.data.hf.ccsds'
%       outdir = 'C:\share\Linux\doc\juice\ccsds\system_test\ql\'
%       ret = HF_dl_script(input_file, outdir)

function ret = HF_dl_script_bin(input_file, outdir)
    %------------------------------------------------------------------------------------
    % User inputs
    %------------------------------------------------------------------------------------
    st_ctl_in.raw_ver1_corrected = 0;
    st_ctl_in.title = '';
    %------------------------------------------------------------------------------------
    
    ql=0;
    st_ctl_in.timeout=5;
    
    [indir_,infile_,inext_] = fileparts(input_file);

    indir = append(indir_, filesep);

    if ~exist('outdir', 'var') 
        outdir = indir_; 
    end
    mkdir(outdir)
    
    infile = append(infile_, inext_);
    [ret_data, st_ctl] = hf_get_packet_bin(input_file);
    
    if ret_data == 1 
        fprintf("HF data in %s\n", infile);
        fprintf("   number of HF packet      : %d\n",st_ctl.n_pkt);
        fprintf("   number of HF data [Byte] : %d\n",st_ctl.out_sz);
    
        st_ctl_in.dir_in  = indir;
        st_ctl_in.dir_out = outdir;
        st_ctl_in.file_in = infile;
        st_ctl_in.format     = 1;
        hf_ccsds_ql_bin(ql, st_ctl_in);
    else
        fprintf("No HF data in %s\n", infile);
    end

    ret = ret_data;

end
