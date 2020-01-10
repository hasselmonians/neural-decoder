
% arguments
index = 1;
location = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster/';
batchname = 'Caitlin-A-NeuralDecoder';
outfile = '/home/alec/code/neural-decoder/output-Caitlin-A-NeuralDecoder-1.csv';
test = true;

neurodec = batchFunction_test(index, location, batchname, outfile, test);

%% test the decoding algorithm

% parameters
new_params = readmatrix(outfile);

% support of the kernel
w = neurodec.getKernelSupport();

% compute the kernel and transformed signal
[~, ~, new_kernel, new_transformed_signal] = neurodec.objective_function(raw_signal, new_params);

figure;
subplot(1, 2, 1); hold on;
plot(w, kernel, 'k')
plot(w, new_kernel, 'r')
xlabel('time (s)')
title('kernels')

subplot(1, 2, 2); hold on;
plot(time, transformed_signal, 'k')
plot(time, new_transformed_signal, 'r')

figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1)

%% Functions

function neurodec = batchFunction_test(index, location, batchname, outfile, test)
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
