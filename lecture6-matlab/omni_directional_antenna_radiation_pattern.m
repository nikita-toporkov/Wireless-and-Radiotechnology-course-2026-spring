clc;
close all;
clear all;
 
%WRITE INPUT COMMAND SUCH THAT AFTER RUNNING THE PROGRAM, THE MATLAB ASKS YOU 'The lower bound of theta in degree=' and assign it as tmin
tmin = input('The lower bound of theta in degree=');
%WRITE INPUT COMMAND SUCH THAT AFTER RUNNING THE PROGRAM, THE MATLAB ASKS YOU 'The upper bound of theta in degree=' and assign it as tmax
tmax = input('The upper bound of theta in degree=');
%WRITE INPUT COMMAND SUCH THAT AFTER RUNNING THE PROGRAM, THE MATLAB ASKS YOU ''The lower bound of phi in degree=' and assign it as pmin
pmin = input('The lower bound of phi in degree=');
%WRITE INPUT COMMAND SUCH THAT AFTER RUNNING THE PROGRAM, THE MATLAB ASKS YOU 'The upper bound of phi in degree=' and assign it as pmax
pmax = input('The upper bound of phi in degree=');
%ASSIGN tinc, pinc and rad as 2, 4, and pi/180 respectively in three lines.
tinc = 2;
pinc = 4;
rad = pi / 180;

theta1=(tmin:tinc:tmax);
phi1=(pmin:pinc:pmax);
theta=theta1.*rad;
phi=phi1.*rad;

%USE meshgrid command such that [THETA,PHI] is meshgrid of (theta,phi);
[THETA,PHI] = meshgrid (theta,phi);
 
y1=input('The field pattern: E(THETA,PHI)=');
v=input('The field pattern: P(THETA,PHI)=','s');
%ASSIGN y AS ABSOLUTE VALUE OF y1
y = abs(y1);
ratio=max(tmax);
[X,Y,Z]=sph2cart(THETA,PHI,y); %learn about sph2cart command
mesh(X,Y,Z); % also learn mesh command
title('3 D Pattern','Color','b','FontName','Helvetica','FontSize',12,'FontWeight','demi');
fprintf('\n Input Parameters: \n-------------------- ');
fprintf('\n Theta =%2.0f',tmin);
fprintf(' : %2.0f',tinc);
fprintf(' : %2.0f',tmax);
fprintf('\n Phi =%2.0f',pmin);
fprintf(' : %2.0f',pinc);
fprintf(' : %2.0f',pmax);
fprintf('\n FIELD PATTERN : %s',v)
fprintf('\n Output is shown in the figure below: \n-------------------- ');
fprintf('\n');