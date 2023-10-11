% ***********************************
% *** 20231007   Y Kasaba
% ***********************************
% Read binary header 10B = "RPWI"(4B) + "SID"(1B) + "AUX-size"(1B) + "HEADER-SIZE(1B) + "SCIENCE-size"(3B)
function [st] = hf_get_hdr_bin(hdr, n_pkt)
    err = 0;

    st.sid          = hdr(5);
    st.size_aux     = hdr(6);
    st.size_hfhead  = hdr(7);
    st.size_sci     = bitshift(hdr(8),16) + bitshift(hdr(9),8) + hdr(10);
    st.pkt_len      = st.size_aux + st.size_hfhead + st.size_sci;
    
    fprintf('<<%d>> ', n_pkt);
    fprintf('header:%c%c%c%c  ', hdr(1),hdr(2),hdr(3),hdr(4));
    fprintf('[sid]%d  [size] aux:%d  HF_header:%d  Sci_data:%d\n', st.sid, st.size_aux, st.size_hfhead, st.size_sci );

    if (hdr(1)~='R' || hdr(2)~='P' || hdr(3)~='W' || hdr(4)~='I') 
        err = 1;
    end
    st.err = err;
end