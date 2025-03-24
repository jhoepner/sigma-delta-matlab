Fs_audio = 48000;      % Audio sampling rate (Hz)
%OSR = 40;
run("delsig/Test_DAC_structures_JS.m");
Fs_sigma_delta = OSR*Fs_audio;  % Sigma-Delta clock rate (64 times the audio rate)
            % Total simulation time (seconds)
N = 300000;               % Number of samples

% Generate an input audio signal
t_audio = (0:N-1) / Fs_audio;
audio_signal = sin(2*pi*1000*t_audio)*0.5; % u_n 

% Computing the exact solution. 
[error_signal_EXACT, quantized_output_EXACT] = DAC5_fixed(audio_signal, N, 64, 64, a, b, g, c);

QuantizedDifference = zeros(64,64);
upper = 63;
lower = 40;
count = 0;
for WLCoeff=lower:upper
    for WLInternal=lower:upper
        [error_signal_QUANT, quantized_output_QUANT] = DAC5_fixed(audio_signal, N, WLCoeff, WLInternal, a, b, g, c);
        diff = sum(abs(quantized_output_EXACT - quantized_output_QUANT));
        QuantizedDifference(WLCoeff-lower+1, WLInternal-lower+1) = diff;
        count = count + 1;
        count/((upper-lower+1)*(upper-lower+1))
    end 
end

[r,c] = find(QuantizedDifference == 0);
figure;
scatter(r+lower,c+lower,'filled')
xlim([lower-1, upper+1])
ylim([lower-1, upper+1])
xticks(lower-1:upper+1)
yticks(lower-1:upper+1)
xlabel('WL for Coefficients');
ylabel('WL for Internal computations ');
title(["Pareto front for all pairs of coefficinet/internal wordlengths", "s.t. the FxP DAC-5 output coincides with the float64 DAC-5", "OSR: " + OSR])



% Plot the results of the exact DAC-3
figure;
subplot(2,1,1);
plot(t_audio, audio_signal);
title('Input Audio Signal');
xlabel('Time (s)');
 
subplot(2,1,2);
plot((0:N-1) / Fs_sigma_delta, quantized_output_EXACT);
title('Quantized Output');
xlabel('Time (s)');
 
% Plot the difference between the exact real signal and the Fixed-Point one
figure(2);
subplot(2,1,1);
plot((0:N-1) / Fs_sigma_delta, error_signal_EXACT - error_signal_QUANT);
title("Error signal difference exact - quantized,  WLCoeff=" + WLCoeff + ", WLInternal=" + WLInternal);
xlabel('Time (s)');
 
% Plot the difference between the exact quantized DAC output and the output 
% of the Fixed-Point DAC. Ideally, this should be a flat line.
subplot(2,1,2);
plot((0:N-1) / Fs_sigma_delta, abs(quantized_output_EXACT - quantized_output_QUANT));
title('Output |Exact - Quantized|, ideally a flat line');
xlabel('Time (s)');
 

