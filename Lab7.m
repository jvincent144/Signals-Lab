%{
% Lab 7
%}

% Load EKG
% load singleSample;
sample = load("singleSample.mat");
normal = sample.normal;
label = sample.label;

% Sampling
fs = 300;

% Fourier Transform of raw signal
FourierFun(normal, fs);

% Spectrogram of raw signal
figure
spectrogram(normal)

% Filtering
f = lsf; % Load MATLAB object into variable
filtered = filter(f, normal);

% Fourier Transform of filtered signal
FourierFun(filtered, fs);

% Spectrogram of filtered signal
figure
spectrogram(filtered)

function FourierFun(signal, fs)
    % Fourier Transform
    comp = fft(signal);
    len = length(signal);
    temp = abs(comp/len);
    mag = temp(1:len/2 + 1); % The positive half of the Fourier spectrum
    mag(2:end - 1) = 2*mag(2:end - 1); % Double the magnitude to account for the negative half of the Fourier spectrum
    
    % Calculate frequencies
    freq = fs*(0:(len/2))/len;
    
    % Calculate time
    dt = 1/fs;
    t = 0:dt:30;
    
    figure
    subplot(211)
    plot(t(1:end-1), signal)
    xlim([15 20])
    xlabel("Time [s]")
    ylabel("Voltage [mV]")
    subplot(212)
    plot(freq, mag)
    xlim([0 70])
    xlabel("f [Hz]")
    ylabel("Magnitude")
end