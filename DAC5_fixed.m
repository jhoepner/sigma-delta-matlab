
function [error_signal,quantized_output]  = DAC5_fixed(audio_signal, N, WLCoeffs, WLInternal, a, b, g, c) 

% Initialize variables
quantized_output = zeros(1, N); 
error_signal = zeros(1, N);
WL = WLInternal;
WL_coeff = WLCoeffs;

b(1) = roundFXP(b(1), WL_coeff);
b(2) = roundFXP(b(2), WL_coeff);
b(3) = roundFXP(b(3), WL_coeff);
b(4) = roundFXP(b(4), WL_coeff);
b(5) = roundFXP(b(5), WL_coeff);
%b(6) is 1
a(1) = 0;
a(2) = 0;
a(3) = 0;
a(4) = 0;
a(5) = 0;

g(1) = roundFXP(g(1), WL_coeff);
g(2) = roundFXP(g(2), WL_coeff);
c(1) = roundFXP(c(1), WL_coeff);
c(2) = roundFXP(c(2), WL_coeff);
c(3) = roundFXP(c(3), WL_coeff);

int1 = 0;
int2 = 0;
int3 = 0;
int5 = 0;
int4 = 0;
g_1 = 0;
g_2 = 0;


un1_plot = zeros(1, N);
un2_plot = zeros(1, N);
un3_plot = zeros(1, N);
un4_plot = zeros(1, N);
un5_plot = zeros(1, N);
un6_plot = zeros(1, N);

int1_plot = zeros(1, N);
int2_plot = zeros(1, N);
int3_plot = zeros(1, N);
int4_plot = zeros(1, N);
int5_plot = zeros(1, N);

g1_plot = zeros(1, N);
g2_plot = zeros(1, N);

% for bitstream output
% fileID = fopen('audio.bin','w');

% CIFB Sigma-Delta modulator loop
for n = 1:N
    audio_sample = audio_signal(n);
    
    %binaryStr = dec2bin(audio_signal(n) * 32767, 16);
    %fprintf(fileID, '%s\n', binaryStr);
    un1 = roundFXP(audio_sample * b(1), WL);
    un1 = roundFXP(un1 + a(1), WL);
    int1 = roundFXP(int1 + un1, WL);
    un1 = roundFXP(int1, WL);

    un2 = roundFXP(audio_sample * b(2), WL);
    un2 = roundFXP(un2 + a(2) - g_1 + un1, WL);
    int2 = roundFXP(int2 + un2, WL);
    un2 = roundFXP(int2, WL);

    un3 = roundFXP(audio_sample * b(3), WL);
    un3 = roundFXP(un3 + un2 + a(3), WL);
    int3 = roundFXP(int3 + un3, WL);
    g_1 = roundFXP(int3 * g(1), WL);
    un3 = roundFXP(int3, WL);

    un4 = roundFXP(audio_sample * b(4), WL);
    un4 = roundFXP(un4 + a(4) - g_2 + un3, WL);
    int4 = roundFXP(int4 + un4, WL);
    un4 = roundFXP(int4, WL);

    un5 = roundFXP(audio_sample * b(5), WL);
    un5 = roundFXP(un5 + a(5) + un4, WL);
    int5 = roundFXP(int5 + un5, WL);
    g_2 = roundFXP(int5 * g(2), WL);
    un5 = roundFXP(int5, WL);

    un6 = roundFXP(audio_sample * b(6) + un5, WL);

    un1_plot(n) = un1;
    un2_plot(n) = un2;
    un3_plot(n) = un3;
    un4_plot(n) = un4;
    un5_plot(n) = un5;
    un6_plot(n) = un6;

    int1_plot(n) = int1;
    int2_plot(n) = int2;
    int3_plot(n) = int3;
    int4_plot(n) = int4;
    int5_plot(n) = int5;

    g1_plot(n) = g_1;
    g2_plot(n) = g_2;

    error_signal(n) = un6;
    
    quantized_output(n) = sign(un6);
    if (un6 < 0) 
        a(1) = b(1);
        a(2) = b(2);
        a(3) = b(3);
        a(4) = b(4);
        a(5) = b(5);
    else
        a(1) = -b(1);
        a(2) = -b(2);
        a(3) = -b(3);
        a(4) = -b(4);
        a(5) = -b(5);
    end

end
% fprintf(fileID, "%d\n", round(quantized_output));
% fclose(fileID);

 % figure(17);
 %    subplot(6,1,1);
 %    plot((0:N-1), un1_plot);
 %    title('un1');
 %    xlabel('Sample');
 % 
 %    subplot(6,1,2);
 %    plot((0:N-1), un2_plot);
 %    title('un2');
 %    xlabel('Sample');
 % 
 %    subplot(6,1,3);
 %    plot((0:N-1), un3_plot);
 %    title('un3');
 %    xlabel('Sample');
 % 
 %    subplot(6,1,4);
 %    plot((0:N-1), un4_plot);
 %    title('un4');
 %    xlabel('Sample');
 % 
 %    subplot(6,1,5);
 %    plot((0:N-1), un5_plot);
 %    title('un5');
 %    xlabel('Sample');
 % 
 %    subplot(6,1,6);
 %    plot((0:N-1), un6_plot);
 %    title('un6');
 %    xlabel('Sample');
 % 
 % 
 %    figure(19);
 %    subplot(7,1,1);
 %    plot((0:N-1), int1_plot);
 %    title('int1');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,2);
 %    plot((0:N-1), int2_plot);
 %    title('int2');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,3);
 %    plot((0:N-1), int3_plot);
 %    title('int3');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,4);
 %    plot((0:N-1), int4_plot);
 %    title('int4');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,5);
 %    plot((0:N-1), int5_plot);
 %    title('int5');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,6);
 %    plot((0:N-1), g1_plot);
 %    title('g1');
 %    xlabel('Sample');
 % 
 %    subplot(7,1,7);
 %    plot((0:N-1), g2_plot);
 %    title('g2');
 %    xlabel('Sample');
