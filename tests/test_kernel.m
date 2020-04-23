%% test script

%% Generate some fake data

% generate time vector
total_time = 300; % seconds
fs = 50; % Hz
time = colon(0, 1/fs, total_time); % seconds

% generate an observable signal
% raw_signal = 25 + 25 * sin(2*pi / (10) * time);
% raw_signal = 25 + 25 * square(2 * pi / 20 * time);
% raw_signal = 5 + randn(length(time), 1);
raw_signal = 0 + 40 * tripuls(time - 150, 100);
raw_signal = raw_signal + 40 * rectpuls(time - 30, 10);
raw_signal = raw_signal + 20 * rectpuls(time - 45, 10);

%% Produce an exponentially-modified Gaussian kernel

bandwidth = 40; % seconds
w = colon(0, 1/fs, bandwidth); % seconds
params = [0.2, 10, sqrt(3), 10];
kernel = exgauss_kernel(w, params);

%% Plot the fake data and the kernel

figure;
subplot(1, 2, 1);
plot(time, raw_signal, 'k');
box off
xlabel('time (s)')
ylabel('animal running speed (cm/s)')
title('sample data')
subplot(1, 2, 2);
plot(w, kernel, 'k')
box off
xlabel('time (s)')
ylabel('kernel')
my_title = { ...
        'exGaussian kernel', ...
        ['(\alpha = ' strlib.oval(params(1), 2) ...
        ', \mu = ' strlib.oval(params(2), 2) ...
        ', \sigma = ' strlib.oval(params(3), 2) ...
        ', \tau = ' strlib.oval(params(4), 2) ')'] ...
        };
title(my_title)
figlib.pretty('PlotBuffer', 0.1)

%% Perform the convolution

transformed_signal = NeuralDecoder.encode(raw_signal, kernel);
spike_train = poissrnd(transformed_signal / fs);

%% Plot the convolution, the spike train, and the raw data

figure;

% plot the raw signal
ax(1) = subplot(3, 1, 1);
title('raw signal')
plot(time, raw_signal, 'k')
ylabel('animal running speed (cm/s)')
box off

% plot the transformed signal
ax(2) = subplot(3, 1, 2);
title('transformed signal')
plot(time, transformed_signal, 'k')
box off
ylabel('firing rate (Hz)')

% plot the spike train
ax(3) = subplot(3, 1, 3);
title('sample spike train')
stem(time, spike_train, 'Marker', 'None', 'Color', [0 0 0])
ylabel('# spikes')
box off

xlabel('time (s)')
linkaxes(ax, 'x');
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1);


% %% Compute the log-likelihood
%
% neurodec = NeuralDecoder;
% neurodec.Fs = fs;
% neurodec.spikeTrain = spike_train;
% neurodec.timestamps = time;
% neurodec.verbosity = true;
%
% loglikelihood = neurodec.loglikelihood(transformed_signal)
