%%% THERMAL NOISE GENERATION %%%
n_samples = 10000;
% Parameter sets for 3x3 grid:
B_vals = [1e6, 900e6, 10e3];    % vary per column in first row
R_vals = [100, 1, 1e6];         % vary per column in second row
T_vals = [300, 250, 310];       % vary per column in third row

% Prepare figure with 3x3 subplots
figure;
thermal_noise = zeros(1, n_samples); % preallocate for compatibility with later code that uses variable
for row = 1:3
    for col = 1:3
        idx = (row-1)*3 + col;
        ax = subplot(3,3,idx);
        hold(ax,'on');
        grid(ax,'on');
        % Select which parameter to vary based on row:
        switch row
            case 1 % vary B, keep R and T fixed (use base R and T from problem)
                B = B_vals(col);
                R = 100;
                T = 300;
                legend_label = sprintf('B=%g Hz', B);
                % make label prettier for common values
                if B==1e6, legend_label = 'B=1MHz'; elseif B==900e6, legend_label='B=900MHz'; elseif B==10e3, legend_label='B=10kHz'; end
            case 2 % vary R, keep B and T fixed (use base B and T)
                B = 1e6;
                R = R_vals(col);
                T = 300;
                if R==100, legend_label = 'R=100 \Omega';
                elseif R==1, legend_label = 'R=1 \Omega';
                else, legend_label = 'R=1e6 \Omega'; end
            case 3 % vary T, keep B and R fixed (use base B and R)
                B = 1e6;
                R = 100;
                T = T_vals(col);
                legend_label = sprintf('T=%g K', T);
                if T==300, legend_label='T=300K'; elseif T==250, legend_label='T=250K'; elseif T==310, legend_label='T=310K'; end
        end
        % Time vector consistent with sampling at B (fs = B)
        time = 0 : 1/B : (n_samples-1) / B;
        % Generate thermal noise (voltage) with RMS sqrt(4*k*T*R*B)
        k = 1.38e-23;
        rms_v = sqrt(4 * k * T * R * B);
        thermal_noise = rms_v * randn(1, n_samples);
        % Plot a short segment for visibility (first 1000 samples or all if fewer)
        nplot = min(1000, n_samples);
        plot(ax, time(1:nplot), thermal_noise(1:nplot));
        xlabel(ax, 'Time (s)');
        ylabel(ax, 'Voltage (V)');
        % Use legend instead of title; display legend and remove legend box
        lg = legend(ax, legend_label);
        set(lg, 'Box', 'off');
        hold(ax,'off');
    end
end

%%% POWER SPECTRAL DENSITY (PSD) ANALISYS %%%

[psd, freq] = pwelch(thermal_noise, [], [], [], B);

% Convert PSD to dB/Hz
psd_db = 10*log10(psd);

% Plot PSD (linear)
figure;
subplot(2,1,1);
plot(freq, psd);
xlabel('Frequency (Hz)');
ylabel('PSD (V^2/Hz)');
title('Power Spectral Density (linear)');
grid on;

% Plot PSD in dB/Hz
subplot(2,1,2);
plot(freq, psd_db);
xlabel('Frequency (Hz)');
ylabel('PSD (dB/Hz)');
title('Power Spectral Density (dB/Hz)');
grid on;

% Estimate total noise power by integrating PSD
noise_power_est = trapz(freq, psd); % V^2
noise_rms_est = sqrt(noise_power_est);

% Theoretical noise power over B: k*T*B*4*R? For voltage across resistor, mean-square noise voltage = 4*k*T*R*B
k = 1.38e-23;
theoretical_noise_power = 4 * k * T * R * B; % V^2 (over bandwidth B)
theoretical_noise_rms = sqrt(theoretical_noise_power);

% Display results
fprintf('Estimated noise power (from PSD) = %.3e V^2\n', noise_power_est);
fprintf('Estimated RMS noise (from PSD) = %.3e V\n', noise_rms_est);
fprintf('Theoretical noise power (4 k T R B) = %.3e V^2\n', theoretical_noise_power);
fprintf('Theoretical RMS noise = %.3e V\n', theoretical_noise_rms);

% Optionally plot theoretical flat PSD level for comparison
% Theoretical one-sided PSD of resistor noise (voltage) is S_v = 4*k*T*R (V^2/Hz)
Sv = 4 * k * T * R;
hold(subplot(2,1,1),'on');
plot(freq, Sv*ones(size(freq)), '--r', 'DisplayName','Theoretical PSD');
legend(subplot(2,1,1),'PSD','Theoretical PSD');

hold(subplot(2,1,2),'on');
plot(freq, 10*log10(Sv)*ones(size(freq)), '--r', 'DisplayName','Theoretical PSD (dB/Hz)');
legend(subplot(2,1,2),'PSD (dB)','Theoretical PSD (dB/Hz)');