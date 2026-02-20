% Parameters 
NoiseDb = input('input SNR in dB. Recommended value is 10 ');
f_signal = input('input signal frequency in Hz. Recommended value is 5 ');
amplitude = input('input Signal Aplitude. Recommended value is 1 ');
Fpass = input('input PassBand Frequency. Recommended value is 35 ');
Fstop = input('input StopBand Frequency. Recommended value is 40 ');

% do not change!
Fs = 1000;  % Sampling Frequency
Apass = 1;           % Passband Ripple (dB)
Astop = 80;          % Stopband Attenuation (dB)
match = 'passband';  % Band to match exactly
h  = fdesign.lowpass(Fpass, Fstop, Apass, Astop, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% signal generation
t = 0:1/Fs:1; 
Signal = amplitude * sin(2*pi*f_signal*t);
SignalNoisy = awgn(Signal,NoiseDb);
SignalFiltered = filter(Hd,Signal);

% plotting
figure;
subplot(3,1,1);
plot(t,Signal);
title('Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,2);
plot(t,SignalNoisy);
title('Signal + White Noise');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(3,1,3);
plot(t,SignalFiltered);
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');
clear;