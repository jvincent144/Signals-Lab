%{
Name: Russel Crowe
Lab: BIOE 162
Session: T
Date: 20 April 2021
%}

% Load ECG Signal
load normalCardioSignal

fs = 300; % Hz
dt = 1/fs; % s
t = 0:dt:30; % s

% 1. Plot the raw signal versus time
figure()
plot(t(1:end - 1), normal)
xlim([15 16])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Raw")

% 2. Label the PQRST complex
text(15.225, 100, 'P', "HorizontalAlignment", "center")
text(15.275, -100, 'Q', "HorizontalAlignment", "center")
text(15.325, 850, 'R', "HorizontalAlignment", "center")
text(15.425, -50, 'S', "HorizontalAlignment", "center")
text(15.565, 150, 'T', "HorizontalAlignment", "center")

% 3. Normalize the signal
maxMag = max(abs(normal));
norm = normal/maxMag;

% 4. Plot the normalized signal
figure()
plot(t(1:end - 1), norm)
xlim([15 16])
xlabel("Time [s]")
ylabel("Magnitude [mV]")
title("Normalized")