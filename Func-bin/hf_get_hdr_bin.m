% ***********************************
% *** 20240713   Y Kasaba
% ***********************************
% Read binary header 18B 
%   = "RPWI"(4B) + "SID"(1B) + "AUX-size"(1B) + "HEADER-SIZE(1B) + "SCI-size"(3B) + "SCET"(8B)
function [st] = hf_get_hdr_bin(hdr, n_pkt)
    err = 0;

    st.sid          = hdr(5);
    st.size_aux     = hdr(6);
    st.size_hfhead  = hdr(7);
    st.size_sci     = bitshift(hdr(8),16) + bitshift(hdr(9),8) + hdr(10);
    st.pkt_len      = st.size_aux + st.size_hfhead + st.size_sci;
    st.time         = bitshift(hdr(11),0) + bitshift(hdr(12),8) + bitshift(hdr(13),16) + bitshift(hdr(14),24) + bitshift(hdr(15),32) + bitshift(hdr(16),40)+ bitshift(hdr(17),48)+ bitshift(hdr(18),56);

    fprintf('<<%d>> ', n_pkt);
    fprintf('header:%c%c%c%c  ', hdr(1),hdr(2),hdr(3),hdr(4));
    fprintf('[sid]%d  [SCET]%d  [size] aux:%d  HF_header:%d  Sci_data:%d\n', st.sid, st.time, st.size_aux, st.size_hfhead, st.size_sci );

    if (hdr(1)~='R' || hdr(2)~='P' || hdr(3)~='W' || hdr(4)~='I') 
        err = 1;
    end
    st.err = err;
end