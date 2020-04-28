%% test_optimization.m
% Use a real speed signal with a known kernel
% and try to reconstruct the kernel, given a spike train generated
% according to a Poisson process.

%% Load the sample data
% loads the "dt", "speed", and "timestamps" variables

load([fileparts(fileparts(mfilename('fullpath'))) filesep 'data/sample_data.mat'])

%% Instantiate a NeuralDecoder object

disp('[INFO] instantiating a NeuralDecoder object')

timestamps = 0:dt:100;

neurodec = NeuralDecoder();
neurodec.Fs = 1 / dt; % Hz
neurodec.bandwidth = 60; % seconds
neurodec.timestamps = timestamps; % seconds
neurodec.verbosity = true;

% overwrite speed with a very simple rectified sine wave
% speed = sin(2 * pi / (1e4 * dt) * timestamps); % + 0.5 * sin(2 * pi / (1e3 * dt) * timestamps);
% speed(speed < 0) = 0;

t = timestamps - timestamps(1);
speed = 5 * rectpuls(t - 50, 0.5/dt);

%% Generate a known kernel

disp('[INFO] generating a known kernel')

w = neurodec.getKernelSupport();
params = [5, 10, 3, 10];
kernel = exgauss_kernel(w, params);

% truncate the kernel
kernel_truncated = params(1) * truncate_kernel(kernel, 'Cutoff', 0.01, 'Normalize', true, 'Verbosity', true);

%% Perform the encoding

disp('[INFO] performing the encoding')

% convolve the kernel and the speed signal
firing_rate_estimate = neurodec.encode(speed, kernel_truncated);
firing_rate_estimate(firing_rate_estimate < eps) = eps;

% generate a spike train
neurodec.spikeTrain = poissrnd(firing_rate_estimate * dt);

%% Visualize the synthetic data

figure;

% plot the raw signal
subplot(3, 1, 1);
plot(timestamps, speed, 'k')
ylabel('animal running speed (cm/s)')
box off

% plot the transformed signal
subplot(3, 1, 2)
plot(timestamps, firing_rate_estimate, 'k')
box off
ylabel('firing rate (Hz)')

% plot the spike train
subplot(3, 1, 3)
stem(timestamps, neurodec.spikeTrain, 'Marker', 'None', 'Color', [0 0 0])
box off
ylabel('# spikes')

xlabel('time (s)')
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1);

return

%% Optimize
% find the kernel estimate

disp('[INFO] beginning optimization process')

% configure options
options = optimoptions('particleswarm');
options.Display = 'iter';
options.UseParallel = true;
options.InitialSwarmMatrix = [0.3, 10, 3, 10];

% cost function should take only one argument, a vector of parameters
fun = @(params) neurodec.objective_function(speed, params);
% lower bounds
lb = [0, 0, 0, 0];
% upper bounds
ub = [100, 100, 100, 100];
[params_opt, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, options);

%% Visualize

[~, ~, kernel_opt, firing_rate_estimate_opt] = neurodec.objective_function(speed, params_opt);

figure;

% plot the two kernels
subplot(2, 1, 1);
hold on
plot(neurodec.getKernelSupport(kernel), kernel, 'k');
plot(neurodec.getKernelSupport(kernel_opt), kernel_opt, 'r');
ylabel('kernel height')
box off

% plot the two transformed signals
subplot(2, 1, 2)
plot(timestamps, firing_rate_estimate, 'k')
plot(timestamps, firing_rate_estimate_opt, 'k')
box off
ylabel('firing rate (Hz)')

xlabel('time (s)')
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1);
