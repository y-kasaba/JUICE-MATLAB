% ***********************************
% *** 20231021   Y Kasaba
% ***********************************
%------------------------------------
% User inputs
%------------------------------------
input_format = 1;   % 0:ccsds      1:bin converted from TMIDX
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/Func/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/Func-bin/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/scripts/')

% ----------------------
if input_format == 0
    % **** CCSDS ****
    basedir_in  = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-TMIDX/202310_EM3/ccsds/";
    basedir_out = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-TMIDX/202310_EM3/result/";
    file_search_str = "*.ccs";
    indir  = [""];
    outdir = [""];
    % indir  = ["CFDP_04_RT_EMC_AC_SC2RIME\CFDP\RETRIEVAL\" "RPWI_NCR\"];
    % outdir = ["Phase4\"  "RPWI_NCR\"];
else
    % **** BIN (from CCSDS or TMIDX) ****
    basedir_in  = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-TMIDX/202310_EM3/bin/";
    basedir_out = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-TMIDX/202310_EM3/result/";
    file_search_str = "*SID04.bin";
    indir  = [""];
    outdir = [""];
end
% ----------------------

% ----------------------
st_ctl_in.raw_ver1_corrected = 0;
st_ctl_in.title = 'HF_EM3_202309';
st_ctl_in.xlim = [0 45];
st_ctl_in.ylim = [-90 -10];
st_ctl_in.cf = -104.1;
%------------------------------------------------------------------------------------

ql = 0;    % DL
st_ctl_in.timeout = 5;

n_dir = numel(indir);
for j=1: n_dir
    tdir = append(basedir_out, outdir(j)); 
    mkdir(tdir)

    s = dir(append(basedir_in, indir(j), file_search_str));
    n_file = numel(s);
    for i=1: n_file
        file = s(i).name;
        infile = append(basedir_in, indir(j), file);
        fprintf("\n[file %d]    %s\n", i, file);
        fprintf("   infile  %s\n", infile);

        if input_format == 0
            outfile = append(basedir_out, outdir(j), file, '.hf.ccsds');
            fprintf("   outfile %s\n", outfile);
            [ret, st_ctl] = hf_get_packet(infile, outfile);
        else
            [ret, st_ctl] = hf_get_packet_bin(infile);
        end

        if ret == 1 
            fprintf("[HF data in %s]", file);
            fprintf("  HF-packet:%d  Length[Byte]:%d\n", st_ctl.n_pkt, st_ctl.out_sz);
            st_ctl_in.dir_in  = append(basedir_in,  indir(j));
            st_ctl_in.dir_out = append(basedir_out, outdir(j));
            st_ctl_in.file_in = file;

            % ----------------------
            if input_format == 0
                [st_ctl_in] = hf_ccsds_ql(ql, st_ctl_in);
            else
                [st_ctl_in] = hf_ccsds_ql_bin(ql, st_ctl_in);
            end
            % ----------------------
        else
            fprintf("No HF data\n");
        end      
    end
end