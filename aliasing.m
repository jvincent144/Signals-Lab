%{
% Name: Joshua Vincent
% Lab: BIOE 162
% Session: M | T
% Date: 25 January 2021
%}

clear

% Set sampling frequencies
fs1 = 300; % Undersampling
fs2 = 900; % Just satisfies Nyquist Theorem
fs3 = 3200; % Oversampling
dt1 = 1/fs1;
dt2 = 1/fs2;
dt3 = 1/fs3;
ns = 10;
t1 = 0:dt1:ns;
t2 = 0:dt2:ns;
t3 = 0:dt3:ns;

% Low frequency sinusoid
a = 1;
f = 440; % A Note
period = f^(-1);
omega = 2*pi*f;
phi = 0;
y1 = a*sin((omega*t1) + phi);
y2 = a*sin((omega*t2) + phi);
y3 = a*sin((omega*t3) + phi);

% Number of periods to display
count = 100;

% Plot sinusoids
figure()
subplot(311)
plot(t1, y1)
xlim([0 count*period])
title("Aliased")
subplot(312)
plot(t2, y2)
xlim([0 count*period])
ylabel("Voltage [mV]")
title("Normal")
subplot(313)
plot(t3, y3)
xlim([0 count*period])
xlabel("Time [s]")
title("Oversampled")