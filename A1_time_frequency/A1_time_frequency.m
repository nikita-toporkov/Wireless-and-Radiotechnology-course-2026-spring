% A1: Time domain and frequency components (FFT)
% Student: Nikita Toporkov
clear; close all; clc;

%% 1) Create time vector
Fs = 10000;              % sampling frequency (samples per second)
T  = 0.05;               % duration in seconds (0.05 s = 50 ms)
t  = 0:1/Fs:T-1/Fs;      % time vector

%% 2) Create the signal Vin(t) in mV
Vin = 10*sin(2*pi*500*t) ...
    + 5*sin(2*pi*600*t) ...
    + 3*sin(2*pi*700*t) ...
    + 5*sin(2*pi*800*t);

%% 3) Plot time domain (first 10 ms)
t_ms = t * 1000;         % convert seconds to milliseconds
index = (t_ms <= 10);    % show only 0..10 ms

figure;
plot(t_ms(index), Vin(index));
grid on;
xlabel('Time [ms]');
ylabel('Amplitude [mV]');
title('A1: Time Domain of V_{in}(t)');

% save figure
exportgraphics(gcf, 'A1_time.png', 'Resolution', 200);

%% 4) FFT (frequency analysis)
N = length(Vin);         % number of samples
X = fft(Vin);            % FFT result (complex values)

% frequency axis
f = (0:N-1) * (Fs/N);

% we plot only 0..Fs/2 (single-sided)
halfN = floor(N/2);
f_half = f(1:halfN);
X_half = X(1:halfN);

% magnitude (how strong each frequency is)
mag = abs(X_half);
figure;
plot(f_half, mag);
grid on;
xlabel('Frequency [Hz]');
ylabel('Magnitude (not normalized)');
title('A1: FFT Magnitude (Frequency Components)');
xlim([0 1200]);
exportgraphics(gcf, 'A1_spectrum.png', 'Resolution', 200);

% Note: You should see big peaks near 500, 600, 700, 800 Hz.