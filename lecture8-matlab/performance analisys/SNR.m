G_t = 1;
G_r = 1;
c = 3*1e8;
Pn = 500*1e-6; %noise power

f_wifi = 2.4*1e9; %IEEE 802.11b
BW_wifi = 22*1e6;
d_wifi = 1:5:100;
P_t_wifi = 100*1e-3;
lamb_wifi = c/f_wifi;

f_bluetooth = 2.45*1e9; %IEEE 802.11
BW_bluetooth = 2*1e6;
d_bluetooth = 0.5:0.5:10;
P_t_bluetooth = 10*1e-3;
lamb_bluetooth = c/f_bluetooth;

f_cellular = 850*1e6; %2G,GSM
BW_cellular = 200*1e3;
d_cellular = 100:100:5000;
P_t_cellular = 40;
lamb_cellular = c/f_cellular;

% Distance vector
R = 1:1:5000;

% Calculate P receiver 
P_output_wifi=(P_t_wifi*G_t*G_r*lamb_wifi.^2)./(4*pi*R).^2;
P_output_bluetooth=(P_t_bluetooth*G_t*G_r*lamb_bluetooth.^2)./(4*pi*R).^2;
P_output_cellular=(P_t_cellular*G_t*G_r*lamb_cellular.^2)./(4*pi*R).^2;

% Calculate SNR
SNR_wifi = P_output_wifi / Pn;
SNR_bluetooth = P_output_bluetooth / Pn;
SNR_cellular = P_output_cellular / Pn;

% Calculate channel capacily
C_wifi = BW_wifi * log2(1 + SNR_wifi);
C_bluetooth = BW_bluetooth * log2(1 + SNR_bluetooth);
C_cellular = BW_cellular * log2(1 + SNR_cellular);

figure;
w1 = subplot(3,3,1);
plot(R,P_output_wifi);
w2 = subplot(3,3,2);
plot(R,P_output_bluetooth);
w3 = subplot(3,3,3);
plot(R,P_output_cellular);

w4 = subplot(3,3,4);
plot(R,SNR_wifi)
w5 = subplot(3,3,5);
plot(R,SNR_bluetooth)
w6 = subplot(3,3,6);
plot(R,SNR_cellular)

w7 = subplot(3,3,7);
plot(R,C_wifi);
w8 = subplot(3,3,8);
plot(R,C_bluetooth);
w9 = subplot(3,3,9);
plot(R,C_cellular);

all_plots = [w1 w2 w3 w4 w5 w6 w7 w8 w9];
for x=1:1:length(all_plots)
    set(all_plots(x),'Xlabel',text('String','Distance, m'));
    set(all_plots(x), 'YScale', 'log');
    set(all_plots(x), 'Xgrid','on','Ygrid','on');
end


set([w1 w4 w7], 'Xlim', [0 10]);
set([w2 w5 w8], 'Xlim', [0 100]);
set([w3 w6 w9], 'Xlim', [0 5000]);

set(w1,'Title',text('String','WiFi','FontSize',16));
set(w2,'Title',text('String','Bluetooth','FontSize',16));
set(w3,'Title',text('String','Cellular','FontSize',16));

set(w1,'Ylabel',text('String','PTX, dB','FontSize',12));
set(w4,'Ylabel',text('String','SNR, dB','FontSize',12));
set(w7,'Ylabel',text('String','Capacity, dB','FontSize',12));