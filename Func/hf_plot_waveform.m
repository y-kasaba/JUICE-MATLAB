function ret = hf_plot_waveform(st_ctl, wave)

    tm = wave.t;
    xi = wave.xi;
    xq = wave.xq;
    yi = wave.yi;
    yq = wave.yq;
    zi = wave.zi;
    zq = wave.zq;
    swp = wave.swp;
    
    ret = 0;
    fig=figure(st_ctl.hf);
    fig.Units = 'centimeters';
    fig.Position = [1.0 1.0 20.0 25.0];     %　[left bottom width height]
    
    % set display layout
    tiledlayout(4,1)

    nexttile(1)
    plot(tm,xq,'r',tm,xi,'b')
    title('Waveform -U ch Red:-Uq,Blue:-Ui')
    xlabel('Time [sec]')
    ylabel('ADC-in [relative V]')

    nexttile(2)
    plot(tm,yq,'r',tm,yi,'b')
    title('Waveform -V ch Red:-Vq,Blue:-Vi')
    xlabel('Time [sec]')
    ylabel('ADC-in [relative V]')

    nexttile(3)
    plot(tm,zq,'r',tm,zi,'b')
    title('Waveform -W ch Red:-Wq,Blue:-Wi')
    xlabel('Time [sec]')
    ylabel('ADC-in [relative V]')

    nexttile(4)
    plot(tm,swp,'r*')
    title('Sweep start')
    xlabel('Time [sec]')
    ylabel('Flag')

    disp('Plot rich data')
    
end
