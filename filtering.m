% PhysioNetDataToMATFormat() % Convert data in training2017, downloaded from the Physionet archive, to MAT-file format
load PhysionetData % Load data from the "mat" file into workspace variables

% Remove short signals and truncate long signals
[Signals, Labels] = segmentSignals(Signals, Labels);

fs = 300; % Sampling rate
ns = 30; % Sample over 30 seconds
t = 0:1/fs:ns; % 1/fs spacing between samples

% Let's look at a single signal
idx = 1;
signal = Signals{idx};
label = Labels(idx);

figure(1)
plot(t(1:end - 1), signal)
xlim([10 15])
title("Electrocardiogram")
xlabel("Time [s]")
ylabel("Amplitude [mV]")
text(12.15, 100, 'P', "HorizontalAlignment", "center")
text(12.25, 900, 'QRS', "HorizontalAlignment", "center")

% Take the Fourier Transform
f = fs*(0:(fs*ns))/(fs*ns);

s = fft(signal); % This is G(s)
s_real = real(s);
s_norm = abs(s_real/(fs*ns));

figure(2)
plot(f(1:(length(f)/2) - 1), s_norm(1:(length(s_norm)/2) - 1))
xlim([0 50])
title("Frequency Spectrum")
xlabel("Frequency [Hz]")
ylabel("Magnitude")

% Instantiate a low pass filter in the Frequency Domain
omega = 20; % Cutoff frequency
num = 1;
denom = [1/omega 1];
sys = tf(num, denom) % This is H(s)

% Look at the filter behavior
figure(3)
bode(sys)

figure(4)
stepplot(sys)

% Apply the low pass filter in the Frequency Domain
coefficients = ((f/omega) + 1).^(-1); % Divide each element by omega, add one to each element, and find the inverse of each element of the frequency array
s_filtered = coefficients(1:end - 1).*s; % Elementwise multiplication of H(s) with G(s)

s_filtered_real = real(s_filtered);
s_filtered_norm = abs(s_filtered_real/(fs*ns));

figure(5)
plot(f(1:(length(f)/2) - 1), s_filtered_norm(1:(length(s_filtered_norm)/2) - 1))
xlim([0 50])
title("Frequency Spectrum")
xlabel("Frequency [Hz]")
ylabel("Magnitude")

signal_filtered = ifft(s_filtered);

figure(6)
plot(t(1:end - 1), signal_filtered)
xlim([10 15])
title("Electrocardiogram")
xlabel("Time [s]")
ylabel("Amplitude [mV]")