clc;
close all;
clear all;

% --- Inputs for Theta ---
tmin = input('The lower bound of theta in degree=');
tmax = input('The upper bound of theta in degree=');

% --- Inputs for Phi ---
pmin = input('The lower bound of phi in degree=');
pmax = input('The upper bound of phi in degree=');

% --- Coordinate Setup ---
% Create vectors and convert to radians
theta = (tmin:tmax) * (pi/180);
phi = (pmin:pmax) * (pi/180);

% Calculate step sizes (differentials)
dth = theta(2) - theta(1);
dph = phi(2) - phi(1);

% Create grid
[THETA, PHI] = meshgrid(theta, phi);

% --- Field and Power Pattern Inputs ---
% x receives the numerical data (e.g., user enters: cos(THETA))
x = input('The field pattern : E(THETA,PHI)='); 

% v receives the string representation for display purposes
v = input('The power pattern: P(THETA,PHI)=', 's');

% --- Beam Area Calculation ---
% Definition: Integral of Pn(theta,phi) * sin(theta) d(theta) d(phi)
% Here Pn is x.^2
Prad = sum(sum((x.^2) .* sin(THETA))) * dth * dph;

% --- Output Display ---
fprintf('\n Input Parameters: \n-------------------- ');
fprintf('\n Theta =%2.0f', tmin);
fprintf(' : %2.0f', dth*180/pi);
fprintf(' : %2.0f', tmax);
fprintf('\n Phi =%2.0f', pmin);
fprintf(' : %2.0f', dph*180/pi);
fprintf(' : %2.0f', pmax);
fprintf('\n POWER PATTERN : %s', v);

fprintf('\n \n Output Parameters: \n-------------------- ');
fprintf('\n BEAM AREA (steradians) = %3.2f\n', Prad);