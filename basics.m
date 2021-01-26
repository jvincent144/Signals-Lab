%{
% Name: Joshua Vincent
% Lab: BIOE 162
% Session: M | T
% Date: 25 January 2021
%}

clear

% Model a simple sinusoid
fs = 300; % This is the sampling rate in the PhysioNet
dt = 1/fs; % Time between samples
ns = 30; % This is the median sample time in PhysioNet
t = 0:dt:ns;
a = 1;
f = 1; % 1 Hz
period = 1/f;
omega = 2*pi*f;
phi = 0;
y = a*sin((omega*t) + phi);

% Plot the data continuously
figure() % Create a new figure
subplot(211) % Switch to first figure
plot(t, y)
xlabel("Time [s]")
ylabel("Magnitude [mV]") % As an example
title("Simple Sinusoid")

% Zoom in on a single sample
subplot(212) % Switch to second row
plot(t, y)
xlim([0 period])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Single Sample")

% Plot the data discretely
figure()
subplot(211)
stem(t, y)
xlabel("Time [s]")
ylabel("Magnitude [mV]") % As an example
title("Simple Sinusoid")
subplot(212)
stem(t, y)
xlim([0 period])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Single Sample")

% Changing between coordinate spaces
a = [10 -13];
b = [-5 3];
[th, r] = cart2pol(a, b); % Cartesian to polar
fprintf("Theta: %f\tR: %f\n", th, r)
[u, v] = pol2cart(th, r); % Polar to cartesian
fprintf("u: %f\tv: %f\n", u, v)

% It is more convenient to perform calculations in polar space
a = [8 3];
b = [5 -6];
[th, r] = cart2pol(a, b); % Cartesian to polar
fprintf("Theta: %f\tR: %f\n", th, r)
z = r.*exp(1j*th);
fprintf("z(1): %f\tz(2): %f\n", z(1), z(2))
product = z(1)*z(2);
quotient = z(1)/z(2);
power = z(1)^3;
fprintf("Product: %f\tQuotient: %f\tPower: %f\n", product, quotient, power) % Only prints real components.
% Convert to polar form
a = [real(product) real(quotient) real(power)];
b = [imag(product) imag(quotient) imag(power)];
[th, r] = cart2pol(a, b)

% Addition of complex numbers in cartesian space
a = [5 3];
b = [5 4];
z = complex(a, b);
sum = z(1) + z(2);
fprintf("Sum: %f\n", sum)

% Addition of complex numbers in polar space
th = [pi/6 pi/5];
r = [2 10];
z = r.*exp(1j*th);
sum = z(1) + z(2);
fprintf("Sum: %f\n", sum)

% Condense multiple sinusoids into a single sinusoids
a = 5;
b = -1;
[c, th] = condense(a, b);
fprintf("c: %f\ttheta: %f\n", c, th)
[th, c] = cart2pol(a, -b);
fprintf("c: %f\ttheta: %f\n", c, th)

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
title("Superposition of Sinusoids")

omega1 = -0.2;
omega2 = pi/4;
a = 3;
y = a*exp(omega1*t).*cos(omega2*t);
subplot(212)
plot(t, y)
xlabel("Time [s]")
ylabel("Magnitude")
title("Exponential Decay of Sinusoid")

% What is the condition to condense sinusoids?
% The sinusoids must have the same angular frequency and phase.
function [c, th] = condense(a, b)
    c = sqrt(a^2 + b^2);
    th = atan(-b/a);
end
