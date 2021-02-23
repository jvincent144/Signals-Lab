%{
Name: Joshua Vincent
Lab: BIOE 162
Section: M
Date: 22 February 2021
%}

% PhysioDataToMATFormat()
load PhysionetData;

% Segment signals into 30 second samples
[signals, labels] = segmentSignals(Signals, Labels);

% Extract single sample
normal = signals{1};
label = labels(1);

% Plot EKG
figure()
plot(normal)
xlim([length(normal)/2 length(normal)*3/4])
title("Normal EKG")
xlabel("Time [s]")
ylabel("Voltage [mV]")

% Normal/Gaussian distrobution
% More specifically, standard normal distribution
mu = 0;
sigma = 1;
k = (-3)*sigma:(1/2)*sigma:(3)*sigma;
kernel = normpdf(k, mu, sigma);

% Plot Kernel
figure()
plot(k, kernel)
title("Gaussian Kernel")
xlabel("Sigma")
ylabel("Point Density")

% Smoothing
smoothed = conv(normal, kernel, "same");

% Plot Smoothed EKG
figure()
plot(smoothed)
xlim([length(normal)/2 length(normal)*3/4])
title("Smoothed EKG")
xlabel("Time [s]")
ylabel("Voltage [mV]")