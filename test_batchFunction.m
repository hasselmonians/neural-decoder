
% arguments
index = 1;
location = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster/';
batchname = 'Caitlin-A-NeuralDecoder';
outfile = '/home/alec/code/neural-decoder/output-Caitlin-A-NeuralDecoder-1.csv';
test = true;

batchFunction_test(index, location, batchname, outfile, test);

function batchFunction_test(index, location, batchname, outfile, test)
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

  %% Particle swarm optimization

  % configure options
  options = optimoptions('particleswarm');
  options.Display = 'off';
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

% %% test the decoding algorithm
%
% %% Generate the validation data set
% % raw signal: the extrinsic, measurable biological signal
% % params: the parameters to be estimated
% %   this vector contains the canonical parameters used
% %   in the production of the spike train
% % kernel: the kernel used to convolve the raw signal
% %   produces the signal transformed_signal
% % spike_train: a spike train produced by the Poisson process
% %   with transformed_signal as the rate function
%
% test_kernel;
% close all
%
% %% Perform the steps in the batch function
%
% % instantiate the NeuralDecoder object
% neurodec              = NeuralDecoder();
% neurodec.spikeTrain   = spike_train;
% neurodec.Fs           = 50; % Hz
% neurodec.timestamps   = time;
% neurodec.verbosity    = true;
% neurodec.bandwidth    = 60; % s
%
% % particle swarm configuration
% options               = optimoptions('particleswarm');
% options.Display       = 'iter';
% options.UseParallel   = true;
%
% % cost function should take only one argument, a vector of parameters
% fun = @(params) neurodec.objective_function(raw_signal, params);
% % lower bounds
% lb = [0, 0, 0, 0];
% % upper bounds
% ub = [2, 10, 10, 10];
%
% % perform particle swarm optimization
% [new_params, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, options);
%
% %% Compare old and new parameters
%
% disp(['Old parameters: ' mat2str(params)])
% disp(['New parameters: ' mat2str(new_params)])
%
% % support of the kernel
% w = neurodec.getKernelSupport();
%
% % compute the kernel and transformed signal
% [~, ~, new_kernel, new_transformed_signal] = neurodec.objective_function(raw_signal, new_params);
%
% figure;
% subplot(1, 2, 1); hold on;
% plot(w, kernel, 'k')
% plot(w, new_kernel, 'r')
% xlabel('time (s)')
% title('kernels')
%
% subplot(1, 2, 2); hold on;
% plot(time, transformed_signal, 'k')
% plot(time, new_transformed_signal, 'r')
%
% figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1)
