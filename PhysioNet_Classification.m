PhysioNetDataToMATFormat() % Convert data in training2017, downloaded from the Physionet archive, to MAT-file format
load PhysionetData % Load data from the "mat" file into workspace variables

% Vizualize Normal and Diseased state signals
normal = Signals{1};
aFib = Signals{4};

subplot(2, 1, 1)
plot(normal)
title("Normal Rhythm")
xlim([4000, 5200])
ylabel("Amplitude (mV)")
text(4330, 150, 'P', "HorizontalAlignment", "center")
text(4370, 850, 'QRS', "HorizontalAlignment", "center")

subplot(2, 1, 2)
plot(aFib)
title("Atrial Fibrillation")
xlim([4000, 5200])
ylabel("Amplitude (mV)")

% Remove short signals and truncate long signals
[Signals, Labels] = segmentSignals(Signals, Labels);

% Separate Normal and Diseased cases
aFibX = Signals(Labels == 'A');
aFibY = Labels(Labels == 'A');

normalX = Signals(Labels == 'N');
normalY = Labels(Labels == 'N');

% Randomly divide into train and test sets
[trainIndA, ~, testIndA] = dividerand(718, 0.9, 0.0, 0.1); % Arguments: cases, train fraction, validation fraction, test fraction
[trainIndN, ~, testIndN] = dividerand(4937, 0.9, 0.0, 0.1);

XTrainA = aFibX(trainIndA);
YTrainA = aFibY(trainIndA);

XTrainN = normalX(trainIndN);
YTrainN = normalY(trainIndN);

XTestA = aFibX(testIndA);
YTestA = aFibY(testIndA);

XTestN = normalX(testIndN);
YTestN = normalY(testIndN);

% Concatenate the trainsets and testsets, respectively
% Oversample the under-represented class
XTrain = [repmat(XTrainA(1:634),7,1); XTrainN(1:4438)];
YTrain = [repmat(YTrainA(1:634),7,1); YTrainN(1:4438)];

XTest = [repmat(XTestA(1:70), 7, 1); XTestN(1:490)];
YTest = [repmat(YTestA(1:70), 7, 1); YTestN(1:490)];

% Define the model
layers = [ ...
    sequenceInputLayer(1)
    bilstmLayer(100, "OutputMode", "last")
    fullyConnectedLayer(2)
    softmaxLayer
    classificationLayer
    ]

options = trainingOptions("adam", ...
    "MaxEpochs", 10, ...
    "MiniBatchSize", 150, ...
    "InitialLearnRate", 0.01, ...
    "SequenceLength", 1000, ...
    "GradientThreshold", 1, ...
    "ExecutionEnvironment", "auto", ...
    "plots", "training-progress", ...
    "Verbose", false);

% Train the network
net = trainNetwork(XTrain, YTrain, layers, options);

% Validate
testPred = classify(net, XTest, "SequenceLength", 1000);
LSTMAccuracy = sum(testPred == YTest)/numel(YTest)*100
figure
confusionchart(YTest, testPred, "ColumnSummary", "column-normalized", ...
    "RowSummary", "row-normalized", "Title", "Confusion Chart for LSTM");