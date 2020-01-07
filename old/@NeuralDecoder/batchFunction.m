function batchFunction(index, location, batchname, outfile, test)

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

  %% Load data

  % load the root object from the specified raw data file
  load(filename);
  root.cel    = cellnum;
  root        = root.AppendKalmanVel;
  speed       = root.svel;

  %% Generate the Bandwidth Estimator

  neurodec    = NeuralDecoder(root);

  %% Particle swarm optimization

  % configure options
  options     = optimoptions('particleswarm');
  options.Display = 'off';
  options.UseParallel = true;

  % cost function should take only one argument, a vector of parameters
  fun = @(params) neurodec.optimize_EMG_kernel(speed, params);
  % lower bounds
  lb = [0, 0, 0, 0];
  % upper bounds
  ub = [100, 100, 100, 100];
  [params, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, options);

  %% Save the data

  writematrix(params, outfile);

end % function
