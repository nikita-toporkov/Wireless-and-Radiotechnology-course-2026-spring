% A2: Filtering a multi-tone signal (beginner version)
% Student: Nikita Toporkov

clear; close all; clc;

%% 1) Create time vector

Fs = 10000;

T  = 0.2;                % longer duration = better frequency resolution

t  = 0:1/Fs:T-1/Fs;

%% 2) Create Vin(t)

Vin = 10*sin(2*pi*500*t) + 5*sin(2*pi*600*t) + 3*sin(2*pi*700*t) + 5*sin(2*pi*800*t);

%% 3) FFT BEFORE filtering

N = length(Vin);

X = fft(Vin);

f = (0:N-1)*(Fs/N);

halfN = floor(N/2);

f_half = f(1:halfN);

mag_before = abs(X(1:halfN));

figure;

plot(f_half, mag_before);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A2: Spectrum BEFORE filtering');

xlim([0 1200]);

exportgraphics(gcf, 'A2_before.png', 'Resolution', 200);

%% 4) Case 1: Get ~500 Hz using LPF (cutoff between 500 and 600)

cutoff = 550;                     % Hz

y500 = lowpass(Vin, cutoff, Fs);  % LPF

X500 = fft(y500);

mag_500 = abs(X500(1:halfN));

figure;

plot(f_half, mag_500);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A2: AFTER LPF (target ~500 Hz)');

xlim([0 1200]);

exportgraphics(gcf, 'A2_after_500.png', 'Resolution', 200);

%% 5) Case 2: Get ~800 Hz using HPF (cutoff between 700 and 800)

cutoff = 750;                      % Hz

y800 = highpass(Vin, cutoff, Fs);  % HPF

X800 = fft(y800);

mag_800 = abs(X800(1:halfN));

figure;

plot(f_half, mag_800);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A2: AFTER HPF (target ~800 Hz)');

xlim([0 1200]);

exportgraphics(gcf, 'A2_after_800.png', 'Resolution', 200);

%% 6) Case 3: Get ~600 Hz using BPF (between 500 and 700)

bp1 = 550; bp2 = 650;                   % Hz

y600 = bandpass(Vin, [bp1 bp2], Fs);    % BPF

X600 = fft(y600);

mag_600 = abs(X600(1:halfN)); 

figure;

plot(f_half, mag_600);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A2: AFTER BPF (target ~600 Hz)');

xlim([0 1200]);

exportgraphics(gcf, 'A2_after_600.png', 'Resolution', 200);

%% 7) Case 4: Get ~700 and ~800 using HPF (cutoff between 600 and 700)

cutoff = 650;

y700_800 = highpass(Vin, cutoff, Fs);
 
X78 = fft(y700_800);

mag_78 = abs(X78(1:halfN));

figure;

plot(f_half, mag_78);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A2: AFTER HPF (target ~700 and ~800 Hz)');

xlim([0 1200]);

exportgraphics(gcf, 'A2_after_700_800.png', 'Resolution', 200);