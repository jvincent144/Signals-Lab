%{
% Name: Joshua Vincent
% Lab: BIOE 162
% Session: M
% Date: 25 January 2021
%}

% Model a simple sinusoid
fs = 300; % This is the sampling rate in the PhysioNet
dt = 1/fs; % Time between samples
ns = 30; % This is the median sample time in PhysioNet
t = 0:dt:ns;
y = sin(t);

% Plot the data continuously
figure() % Create a new figure
subplot(211) % Switch to first figure
plot(t, y)
xlabel("Time [s]")
ylabel("Magnitude [mV]") % As an example
title("Simple Sinusoid")

% Zoom in on a single sample
subplot(212) % Switch to second row
xlim([0 dt])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Single Sample")

% Plot the data discretely
figure()
stem(t, y)
xlabel("Time [s]")
ylabel("Magnitude [mV]") % As an example
title("Simple Sinusoid")

% Changing between coordinate spaces
a = [10 -13];
b = [-5 3];
[th, r] = cart2pol(a, b); % Cartesian to polar
[u, v] = pol2cart(th, r); % Polar to cartesian

% It is more convenient to perform calculations in polar space
a = [8 3];
b = [5 -6];
[th, r] = cart2pol(a, b); % Cartesian to polar
z = r.*exp(1j*th);
product = z(1)*z(2);
quotient = z(1)/z(2);
power = z(1)**3;

% Addition of complex numbers in cartesian space
a = [5 3];
b = [5 4];
z = complex(a, b);
sum = z(1) + z(2);

% Addition of complex numbers in polar space
th = [pi/6 pi/5];
r = [2 10];
z = r.*exp(1j*th);
sum = z(1) + z(2);

% Condense multiple sinusoids into a single sinusoids
a = 5;
b = -1;
[c, th] = condense(a, b);

% What is the condition to condense sinusoids?
% The sinusoids must have the same angular frequency and phase.
function [c, th] = condense(a, b)
    c = atan(-b/a);
    th = acos(a/c);
end

% Plotting sinusoids and exponentially-varying sinusoids
t = 0:dt:50;
figure()

omega = pi/10;
theta = pi/3;
a = 3;
b = 2;
y = (a*cos((omega*t) + theta)) + (b*sin(omega*t));
subplot(211)
plot(t, y)
xlabel("Time [s]")
ylabel("Magnitude")

omega1 = -0.2;
omega2 = pi/4;
a = 3;
y = a*exp(omega1*t)*cos(omega2*t);
subplot(212)
xlabel("Time [s]")
ylabel("Magnitude")
