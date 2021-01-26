%{
% Name: Joshua Vincent
% Lab: BIOE 162
% Session: M | T
% Date: 25 January 2021
%}

clear

% Model a simple sinusoid
fs = 6400;
dt = 1/fs;
ns = 10;
t = 0:dt:ns;

% Low frequency
a = 1;
fa = 440; % A Note
perioda = fa^(-1);
omegaa = 2*pi*fa;
phia = 0;
ya = a*sin((omegaa*t) + phia);

% Higher frequency
b = 1;
fb = 784; % G Note
periodb = fb^(-1);
omegab = 2*pi*fb;
phib = 0;
yb = b*sin((omegab*t) + phib);

% Superposition
yab = ya + yb;

% Number of periods to display
count = 10;

% Plot 'A' Note
figure()
subplot(311)
plot(t, ya)
xlim([0 count*perioda])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("A Note")

% Plot 'G' Note
subplot(312)
plot(t, yb)
xlim([0 count*periodb])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("G Note")

% Plot Superposition
subplot(313)
plot(t, yab)
xlim([0 count*perioda])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Superposition")

L = length(yab);
Yab = fft(yab);
% Calculate the double-sided spectrum
P2 = abs(Yab/L);
% Calculate the single-sided spectrum
P1 = P2(1:(L/2) + 1);
P1(2:end - 1) = 2*P1(2:end-1);

% Frequencies
f = fs*(0:(L/2))/L;

% Plot the single-sided specturm
figure()
plot(f, P1)
xlabel("f [Hz]")
ylabel("|P1(f)|")
title("Single-Sided Amplitude Spectrum")