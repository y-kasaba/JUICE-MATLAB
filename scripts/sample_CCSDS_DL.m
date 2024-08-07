% ***********************************
% *** 20240201   Y Kasaba
% ***********************************
%------------------------------------
% User inputs
%------------------------------------
input_format = 0;   % 0:ccsds      1:bin converted from TMIDX
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/Func/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/Func-bin/')
%addpath('/Users/user/Documents/MATLAB/JUICE/HF-QL/scripts/')

% ----------------------
if input_format == 0
    % **** CCSDS ****
    % basedir_in  = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/sample/ccsds/";
    % basedir_out = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/sample/result/";
    % file_search_str = "*.ccs";
    basedir_in  = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/IRFU/ccsds/";
    basedir_out = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/IRFU/result/";
    file_search_str = "*.dat";
    indir  = [""];
    outdir = [""];
    % indir  = ["CFDP_04_RT_EMC_AC_SC2RIME\CFDP\RETRIEVAL\" "RPWI_NCR\"];
    % outdir = ["Phase4\"  "RPWI_NCR\"];
else
    % **** BIN (from CCSDS or TMIDX) ****
    basedir_in  = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/sample/bin/";
    basedir_out = "/Users/user/Google-Univ/TU/TU_C_staffs/C-Space/JUICE/data/test-CCSDS/sample/result/";
    file_search_str = "*.bin";
    indir  = [""];
    outdir = [""];
end
% ----------------------

n_dir = numel(indir);
for j=1: n_dir
    tdir = append(basedir_out, outdir(j)); 
    mkdir(tdir)

    s = dir(append(basedir_in, indir(j), file_search_str));
    n_file = numel(s);

    for i=1: n_file
        file = s(i).name;
        input_file = append(basedir_in,   indir(j), file);
        output_dir = append(basedir_out, outdir(j));

        if input_format == 0
            ret = HF_dl_script    (input_file, output_dir);
        else
            ret = HF_dl_script_bin(input_file, output_dir);
        end
    end
end
