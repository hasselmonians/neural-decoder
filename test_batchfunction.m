%% Generate some fake data

% generate time vector
total_time = 100; % seconds
fs = 50; % Hz
time = colon(0, 1/fs, total_time); % seconds

% generate an observable signal
% raw_signal = 25 + 25 * sin(2*pi / (10) * time);
% raw_signal = 25 + 25 * square(2 * pi / 20 * time);
raw_signal = 5 + 20 * rectpuls(time - 30, 10) + 20 * rectpuls(time - 60, 10);

%% Produce an exponentially-modified Gaussian kernel

bandwidth = 15; % seconds
w = colon(0, 1/fs, bandwidth); % seconds
params = [0.2, 3, sqrt(3), 0.1];
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
spike_train = poissrnd(transformed_signal);

%% Plot the convolution, the spike train, and the raw data

figure;

% plot the raw signal
subplot(3, 1, 1);
plot(time, raw_signal, 'k')
ylabel('animal running speed (cm/s)')
box off

% plot the transformed signal
subplot(3, 1, 2)
plot(time, transformed_signal, 'k')
box off
ylabel('firing rate (Hz)')

% plot the spike train
subplot(3, 1, 3)
stem(time, spike_train, 'Marker', 'None', 'Color', [0 0 0])
ylabel('# spikes')
box off

xlabel('time (s)')
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1);

%% Instantiate the NeuralDecoder object

neurodec              = NeuralDecoder();
neurodec.spikeTrain   = spike_train;
neurodec.Fs           = 50; % Hz
neurodec.timestamps   = time;
neurodec.verbosity    = true;
neurodec.bandwidth    = 60; % s

%% Instantiate the nldat object

iodata = nldat([raw_signal; transformed_signal]', ...
  'domainincr', 1/neurodec.Fs, ...
  'domainvalues', neurodec.timestamps, ...
  'domainname', 'Time',...
  'chanunits', { 'a.u.', 'Hz'}, ...
  'channames', { 'extrinsic signal', 'firing rate'});

% compute the impulse response function
% using the pseudo-inverse IRF approximation algorithm

h = irf(iodata, 'nlags', 30*fs, 'mode', 'auto');

figure;
plot(h)
