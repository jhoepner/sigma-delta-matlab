Fs_audio = 384000;    % Audio sampling rate (Hz)
%OSR = 128; % set in Test_DAC_Structures_JS.m
% SD order is set there too

run("delsig/Test_DAC_structures_JS.m");
Fs_sigma_delta = OSR*Fs_audio;  % Sigma-Delta clock rate (64 times the audio rate)
N = 4000000;               % Number of samples
%N = 30000000;
% Generate an input audio sigpwdnal
t_audio = (0:N-1) / Fs_sigma_delta;
audio_signal = sin(2*pi*1000*t_audio)*0.5;% u_n % 0.62 seems to work
% Computing the exact solution. 
[error_signal_EXACT, quantized_output_EXACT] = DAC5_fixed(audio_signal, N, 64, 64, 64, a, b, g, c);
% Computing the quantized solution with coefficients in 17 bits
% and all internal operations quantized to 37 bits 
WLCoeff = 17;
WLInternal= 33;
[error_signal_QUANT, quantized_output_QUANT] = DAC5_fixed(audio_signal, N, WLCoeff, WLInternal, a, b, g, c);


Plot the results of the exact DAC-3
figure(10);
subplot(3,1,1);
plot((0:N-1), audio_signal);
title('Input Audio Signal');
xlabel('Time (s)jj');

subplot(3,1,2);
stairs((0:N-1), quantized_output_EXACT);
title("Quantized Output exact" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
xlabel('Time (s)hg');


subplot(3,1,3);
plot((0:N-1), error_signal_EXACT);
title("error Output exact" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
xlabel('Time (s)');


figure(9);

subplot(3,1,1);
plot((0:N-1), audio_signal);
title('Input Audio Signal');
xlabel('Time (s)jj');

subplot(3,1,2);
stairs((0:N-1), quantized_output_QUANT);
title("Quantized Output QUANZ" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
xlabel('Time (s)hg');


subplot(3,1,3);
plot((0:N-1), error_signal_QUANT);
title("error Outpu QUANZt" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
xlabel('Time (s)');

Plot the difference between the exact real signal and the Fixed-Point one
figure(11);
subplot(2,1,1);
plot((0:N-1), error_signal_EXACT - error_signal_QUANT);
title("signal difference exact - quantized,  WLCoeff=" + WLCoeff + ", WLInternal=" + WLInternal + "OSR=" + OSR);
xlabel('Time (s)');

% Plot the difference between the exact quantized DAC output and the output 
% of the Fixed-Point DAC. Ideally, this should be a flat line.
subplot(2,1,2);
plot((0:N-1), abs(quantized_output_EXACT - quantized_output_QUANT));
title('Output |Exact - Quantized|, ideally a flat line');
xlabel('Time (s)');



% Compute FFT of the DAC output
fftinput = quantized_output_QUANT;
fftlength = length(fftinput); % Length of the signal
Y = fft(fftinput)/fftlength; % Normalize the FFT

% Compute the frequency vector
frequencies = Fs_sigma_delta*(0:(fftlength/2))/fftlength;

% Plot single-sided amplitude spectrum
%figure(20);
% plot(frequencies, 2*abs(Y(1:fftlength/2+1)));
% title("Single-Sided Amplitude Spectrum of DAC Output" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
% xlabel('Frequency (Hz)');
% ylabel('Amplitude');

figure(21);
plot(frequencies, 20*log10(2*abs(Y(1:fftlength/2+1))));
xscale log;
title("Single-Sided Amplitude Spectrum of DAC Output (dB)" + "WL:i" + WLInternal + ",c:" + WLCoeff + ", OSR:" + OSR);
xlabel('Frequency (Hz)');
ylabel('Amplitude (dB)');

% plot in dB scale
figure(23);
xscale log;
snrdacwithoutfilter = snr(fftinput, Fs_sigma_delta, 2)
lp = lowpass(fftinput, 24000, Fs_sigma_delta,ImpulseResponse="iir",Steepness=0.9999999999999, StopbandAttenuation=150);
snr(lp, Fs_sigma_delta, 5)

