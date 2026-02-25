%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% RF Planning Studio
% Goal: See how simple design choices change link feasibility.
% You will test 4 what-if changes:
% 1) Increase gateway height by +5 m
% 2) Increase antenna gain to 5 dBi
% 3) Change environment exponent n
% 4) Move gateway location (modeled as obstacle position along the path)
clear; clc; close all;
%% -------------------------
% Baseline link parameters
%% -------------------------
c = 3e8;
f = 868e6; % Hz
lambda = c/f;
D = 4000; % m (link length)
Ptx = 14; % dBm
Gtx = 2; Grx = 2; % dBi
Lcable = 1; % dB (cable+connectors)
Srx = -120; % dBm (given from Noise lecture)
fadeMargin = 10; % dB (safety margin)
htx = 20; hrx = 2; % m (gateway, sensor)
n = 2.7; % environment exponent (suburban-ish)
% Obstacle (for Fresnel study)
xObs = 0.5*D; % obstacle position (m) along the link (0..D)
hObsAboveLOS = 3; % m above LOS line (simplified)
clearRatio = 0.60; % 60% Fresnel clearance rule
%% -------------------------
% Helper formulas
%% -------------------------
FSPL = @(fHz, d) (20*log10(fHz) + 20*log10(d) - 147.55); % dB, f in Hz, d in m
PLlog = @(PL0, d, d0, n) (PL0 + 10*n*log10(d./d0)); % log-distance model
EIRP = @(Ptx, Gtx, Lc) (Ptx + Gtx - Lc); % dBm
PrxFun = @(EIRP, Grx, PL, m) (EIRP + Grx - PL - m); % dBm
% Fresnel radius at position x on a link of length D
FresnelR = @(lambda, x, D) sqrt((lambda .* x .* (D-x)) ./ D);
%% -------------------------
% Distance sweep for plots
%% -------------------------
d = logspace(log10(200), log10(12000), 300); % meters
dkm = d/1000;
d0 = 100; % reference distance
PL0 = FSPL(f, d0); % anchor loss at d0
% Baseline
PL = PLlog(PL0, d, d0, n);
Prx = PrxFun(EIRP(Ptx,Gtx,Lcable), Grx, PL, fadeMargin);
%% -------------------------
% Fresnel check (single-point, practical)
%% -------------------------
rF = FresnelR(lambda, xObs, D);
requiredClear = clearRatio * rF;
fresnelOK = (hObsAboveLOS < requiredClear);
%% -------------------------
% Plot baseline
%% -------------------------
figure('Name','RF Planning Studio (Short)');
semilogx(dkm, Prx, 'LineWidth', 2); grid on; hold on;
yline(Srx, '--', 'Sensitivity', 'LineWidth', 1.5);
xlabel('Distance (km)');
ylabel('Received power after margin (dBm)');
title(sprintf('Baseline: f=%.0f MHz, n=%.1f, Gtx=%.0f dBi, Grx=%.0f dBi', f/1e6, n, Gtx, Grx));
%% Print baseline results
maxLOS = 3.57*(sqrt(htx) + sqrt(hrx)); % km
fprintf('--- BASELINE ---\n');
fprintf('Max LOS distance (approx): %.1f km\n', maxLOS);
fprintf('Fresnel @ x=%.0f%%: r=%.2f m, 60%%=%.2f m, obstacle=%.2f m => %s\n', ...
100*xObs/D, rF, requiredClear, hObsAboveLOS, string(fresnelOK));
%% =========================================================
% EXPERIMENTS (Students edit ONLY these sections)
%% =========================================================
%% (1) Increase gateway height by +5 m
htx_1 = htx + 5;
maxLOS_1 = 3.57*(sqrt(htx_1) + sqrt(hrx)); % km
fprintf('\n(1) Height +5m => Max LOS: %.1f km\n', maxLOS_1);
% Note: Height affects geometry/clearance more than PL model (unless you have terrain data).
%% (2) Increase antenna gains to 5 dBi
Gtx_2 = 5; Grx_2 = 5;
Prx_2 = PrxFun(EIRP(Ptx,Gtx_2,Lcable), Grx_2, PL, fadeMargin);
semilogx(dkm, Prx_2, 'LineWidth', 2);
fprintf('(2) Gains to 5 dBi => curve added\n');
%% (3) Change environment exponent n
n_3 = 3.5; % try 2.0, 2.7, 3.5, 4.0
PL_3 = PLlog(PL0, d, d0, n_3);
Prx_3 = PrxFun(EIRP(Ptx,Gtx,Lcable), Grx, PL_3, fadeMargin);
semilogx(dkm, Prx_3, 'LineWidth', 2);
fprintf('(3) Exponent n=%.1f => curve added\n', n_3);
%% (4) Move gateway location (change obstacle position)
% Move xObs closer to TX or RX and see how Fresnel radius changes.
xObs_4 = 0.3*D; % try 0.1*D, 0.3*D, 0.5*D, 0.7*D, 0.9*D
rF_4 = FresnelR(lambda, xObs_4, D);
requiredClear_4 = clearRatio * rF_4;
fresnelOK_4 = (hObsAboveLOS < requiredClear_4);
fprintf('(4) Obstacle at %.0f%% => r=%.2f m, 60%%=%.2f m => %s\n', ...
100*xObs_4/D, rF_4, requiredClear_4, string(fresnelOK_4));
legend('Baseline','Sensitivity','Gain=5 dBi','n=3.5','Location','best');