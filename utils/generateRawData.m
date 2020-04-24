function raw_signal = generateRawData()

    % generate time vector
    total_time = 300; % seconds
    fs = 50; % Hz
    time = colon(0, 1/fs, total_time); % seconds

    % generate an observable signal
    raw_signal = 0 + 40 * tripuls(time - 150, 100);
    raw_signal = raw_signal + 40 * rectpuls(time - 30, 10);
    raw_signal = raw_signal + 20 * rectpuls(time - 45, 10);

end % function
