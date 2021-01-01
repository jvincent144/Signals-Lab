function PhysioNetDataToMATFormat()
    % Check if the data is downloaded
    if 7 ~= exist("training2017", "dir")
        unzip("https://archive.physionet.org/challenge/2017/training.zip")
    end
    
    % Once the data is downloaded...
    cd training2017; % Navigate to the training2017 directory
    ref = "REFERENCE.csv"; % Load the table from RERENCE.csv
    
    tbl = readtable(ref, "ReadVariableNames", false); % Create a table to store the labels and filenames
    tbl.Properties.VariableNames = ["Filename", "Label"];
    
    % Delete Other Rhythm and Noisy Recording signals
    toDelete = strcmp(tbl.Label, 'O') | strcmp(tbl.Label, '~');
    tbl(toDelete,:) = [];
    
    % Load each file in the table
    H = height(tbl);
    for ii = 1:H
        fileData = load(strcat(tbl.Filename{ii}, ".mat"));
        tbl.Signal{ii} = fileData.val;
    end
    
    % Leave the training2017 directory
    cd ..
    
    % Format the data for LSTM training
    % Signals: Cell array of predictors
    % Labels: Categorical array of responses
    Signals = tbl.Signal;
    Labels = categorical(tbl.Label);
    
    save PhysionetData.mat Signals Labels % Save the variables to a MAT-file
end