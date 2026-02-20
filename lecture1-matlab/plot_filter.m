%% 1. Generate a Signal

fs = 4000;              % Sampling frequency (Hz)
t = 0:1/fs:1-1/fs;      % Time vector (1 second)

mixedSignal = sin(2*pi*100*t)+sin(2*pi*200*t)+sin(2*pi*300*t)+sin(2*pi*400*t);

%% 2. Apply the Filter

filteredSignal = filter(Hd, mixedSignal); 

%% 3. Plotting the Results
figure;

% Plot Original Mixed Signal
subplot(2,1,1);
plot(t, mixedSignal);
title('Input Signal');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0,0.05]);
grid on;

% Plot Filtered Signal
subplot(2,1,2);
plot(t, filteredSignal);
title('Filtered Signal (Noise Removed)');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0,0.05]);
grid on;

%% 4. Frequency Domain Analysis (FFT)
L = length(mixedSignal);           % Length of signal
f = (0:(L/2)) * (fs/L);            % Frequency vector (0 to Nyquist)

% Compute FFT of Mixed Signal
Y_mixed = fft(mixedSignal);
P2_mixed = abs(Y_mixed/L);         % Two-sided spectrum
P1_mixed = P2_mixed(1:L/2+1);      % Single-sided spectrum
P1_mixed(2:end-1) = 2*P1_mixed(2:end-1);

% Compute FFT of Filtered Signal
Y_filt = fft(filteredSignal);
P2_filt = abs(Y_filt/L);
P1_filt = P2_filt(1:L/2+1);
P1_filt(2:end-1) = 2*P1_filt(2:end-1);
%% 5. Plotting Frequency Components
figure;

% Mixed Signal Spectrum
subplot(2,1,1);
stem(f, P1_mixed, 'Marker', 'none'); 
title('Single-Sided Amplitude Spectrum (Mixed Signal)');
xlabel('Frequency (Hz)');
ylabel('|P1(f)|');
grid on;
axis([0 800 0 1.2]); % Zoom in on frequencies of interest (0-100Hz)

% Filtered Signal Spectrum
subplot(2,1,2);
stem(f, P1_filt, 'Marker', 'none');
title('Single-Sided Amplitude Spectrum (Filtered Signal)');
xlabel('Frequency (Hz)');
ylabel('|P1(f)|');
grid on;
axis([0 800 0 1.2]);

clear f filteredSignal fs L mixedSignal P1_filt P1_mixed P2_filt P2_mixed t Y_filt Y_mixed;
