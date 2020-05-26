%% test_spaced_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.
% Sample according to a logarithmically spaced grid.

% path to where data should be saved
% data_path = fullfile(pathlib.strip(mfilename('fullpath'), 2), 'data', 'test_spaced_kernel.mat');

%% Acquire the raw data

% load sample raw data
[~, neurodec, root] = generateRawData();

% instantiate options
options             = struct;
options.Bandwidth   = 60;
options.dt          = 1 / 50;
options.Params      = [0.2, 10, sqrt(3), 10];
options.Signal      = root.svel;
options.Timestamps  = root.ts;
options.Verbosity   = true;

% perform the convolution with a known kernel
[firing_rate_estimate, neurodec, options] = generateSampleData(options);

% generate a spike train from the convolved signal
neurodec.spikeTrain = poissrnd(firing_rate_estimate);

%% Particle swarm optimization

% configure options
optim_option                     = optimoptions('particleswarm');
optim_option.Display             = 'iter';
optim_option.UseParallel         = true;
optim_option.InitialSwarmMatrix  = [1, 10, 3, 3];

% cost function should take only one argument, a vector of parameters
fun = @(params) neurodec.objective(speed, params);
% lower bounds
lb = [0, 0, 0, 0];
% upper bounds
ub = [2, 30, 30, 15];

% perform optimization procedure
[params, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, optim_option);

%% Test

corelib.verb(true, 'neural-decoder/test_parameter_optimization', ['The original parameters were:'])
disp(options.Params)

corelib.verb(true, 'neural-decoder/test_parameter_optimization', ['The new parameters are:'])
disp(params)
