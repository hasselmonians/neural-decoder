
% arguments
index = 1;
location = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster/';
batchname = 'Caitlin-A-NeuralDecoder';
outfile = '/home/alec/code/neural-decoder/output-Caitlin-A-NeuralDecoder-1.csv';
test = true;

[neurodec, speed] = batchFunction_test(index, location, batchname, outfile, test);

%% test the decoding algorithm

% parameters
params = readmatrix(outfile);

% compute the kernel and transformed signal
[~, ~, kernel, firing_rate] = neurodec.objective_function(speed, params);

%% visualize the results

% plot the kernel as a function of lag time
figure;
plot(neurodec.getKernelSupport(kernel), kernel);
xlabel('lag (s)')
ylabel('kernel')
figlib.pretty('PlotBuffer', 0.1);

% plot the speed and the firing rate estimate
figure; hold on
plot(neurodec.timestamps, rescale(speed), 'k');
plot(neurodec.timestamps, rescale(firing_rate), 'r');
xlabel('time (s)')
ylabel('signal (a.u.)')
legend({'speed', 'firing rate'});
figlib.pretty('PlotBuffer', 0.1);

% plot the spike train and the firing rate estimate
figure; hold on
stem(neurodec.timestamps, neurodec.spikeTrain, 'Marker', 'None', 'Color', [0 0 0])
plot(neurodec.timestamps, firing_rate, 'r');
xlabel('time (s)')
legend({'PSTH', 'firing rate'})
figlib.pretty('PlotBuffer', 0.1);

%% Functions

function [neurodec, speed] = batchFunction_test(index, location, batchname, outfile, test)
  %% Preamble

  if nargin < 4
    test = false;
  end

  % if test is false, do not add to the matlab path
  if ~test
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/neural-decoder/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/ex-gaussian/'))
    import CMBHOME.*
  end

  %% Read data

  [filename, cellnum] = RatCatcher.read(index, location, batchname);
  filename = strrep(filename, 'projectnb', 'mnt'); % NOTE: remove in final version

  %% Load data

  % load the root object from the specified raw data file
  load(filename);
  root.cel = cellnum;
  root = root.AppendKalmanVel;
  speed = root.svel;

  %% Generate the Bandwidth Estimator

  neurodec = NeuralDecoder(root);
  neurodec.bandwidth = 60; % s

  %% Particle swarm optimization

  % configure options
  options = optimoptions('particleswarm');
  options.Display = 'iter';
  options.InitialSwarmMatrix = [1, 10, 3, 10];
  options.UseParallel = true;

  % cost function should take only one argument, a vector of parameters
  % so create anonymous function and bind to variable
  fun = @(params) objective_function(neurodec, speed, params);
  % lower bounds
  lb = [0, 0, 0, 0];
  % upper bounds
  ub = [100, 100, 100, 100];
  [params, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, options);

  %% Save the data

  writematrix(params, outfile);

end % function
