% A3: Basic modulation by multiplication (beginner version)
% Student: Nikita Toporkov
clear; close all; clc;

%% 1) Time vector

Fs = 20000;
T  = 0.1;
t  = 0:1/Fs:T-1/Fs;

%% 2) Baseband and carrier

fm = 100;        % message frequency [Hz]
fc = 2000;       % carrier frequency [Hz]

m = sin(2*pi*fm*t);      % baseband (message)
c = cos(2*pi*fc*t);      % carrier

%% 3) Modulated signal (passband)

s = m .* c;

%% 4) Plot baseband time domain

figure;

plot(t*1000, m);

grid on;

xlabel('Time [ms]');

ylabel('Amplitude');

title('A3: Baseband m(t)');

exportgraphics(gcf, 'A3_baseband_time.png', 'Resolution', 200);

 

%% 5) Plot passband time domain (zoom first 5 ms)

index = (t <= 0.005);

 

figure;

plot(t(index)*1000, s(index));

grid on;

xlabel('Time [ms]');

ylabel('Amplitude');

title('A3: Passband s(t) = m(t) \cdot cos(2\pi f_c t)');

exportgraphics(gcf, 'A3_passband_time.png', 'Resolution', 200);

 

%% 6) FFT for baseband

N = length(m);

M = fft(m);

f = (0:N-1)*(Fs/N);

 

halfN = floor(N/2);

f_half = f(1:halfN);

 

mag_m = abs(M(1:halfN));

 

figure;

plot(f_half, mag_m);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A3: Spectrum of Baseband m(t)');

xlim([0 1000]);

exportgraphics(gcf, 'A3_baseband_spectrum.png', 'Resolution', 200);

 

%% 7) FFT for modulated signal

S = fft(s);

mag_s = abs(S(1:halfN));

 

figure;

plot(f_half, mag_s);

grid on;

xlabel('Frequency [Hz]');

ylabel('Magnitude');

title('A3: Spectrum of Modulated Signal s(t)');

xlim([0 5000]);

exportgraphics(gcf, 'A3_passband_spectrum.png', 'Resolution', 200);

 

% Expected: peaks around fc-fm and fc+fm (about 1900 Hz and 2100 Hz).