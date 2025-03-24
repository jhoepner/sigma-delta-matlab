Fs_audio = 48000;    % Audio sampling rate (Hz)
%OSR = 40; % set in Test_DAC_Structures_JS.m
% SD order is set there too

run("delsig/Test_DAC_structures_JS.m");
Fs_sigma_delta = OSR*Fs_audio;  % Sigma-Delta clock rate (64 times the audio rate)
N = 4000000;               % Number of samples
% Generate an input audio signal
t_audio = (0:N-1) / Fs_sigma_delta;
audio_signal = sin(2*pi*1000*t_audio)*0.5;% u_n 


begin = 11;
ende = 24;
data = zeros(begin-ende, begin-ende);

for WLCoeff = begin:ende
    internal_begin = WLCoeff;
    if internal_begin < 19
        internal_begin = 19;
    end
    for WLInternal = internal_begin:ende
        [error_signal_QUANT, quantized_output_QUANT] = DAC5_fixed(audio_signal, N, WLCoeff, WLInternal, a, b, g, c);

        lp = lowpass(quantized_output_QUANT, 24000, Fs_sigma_delta,ImpulseResponse="iir",Steepness=0.9999999999999, StopbandAttenuation=350);
        snr_value = snr(lp, Fs_sigma_delta);
        disp(["SNR for WLCoeff = " WLCoeff " and WLInternal =" WLInternal ": " snr_value " dB"]);
        data(WLCoeff - begin + 1, WLInternal-begin+1) = snr_value;
    end
end
writematrix(data, "bitwidthdata.csv");

figure(7);
[x, y] = meshgrid(begin:ende, begin:ende);

% Plot the surface
data(data==0) = nan;
surf(x, y, data);
title('SNR for Wordlength of internal Calculations and Coefficients');
xlabel('WL internal Calculations');
ylabel("WL Coefficients");