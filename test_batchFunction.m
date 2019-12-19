%% test the decoding algorithm

%% Generate the validation data set
% raw signal: the extrinsic, measurable biological signal
% params: the parameters to be estimated
%   this vector contains the canonical parameters used
%   in the production of the spike train
% kernel: the kernel used to convolve the raw signal
%   produces the signal transformed_signal
% spike_train: a spike train produced by the Poisson process
%   with transformed_signal as the rate function

test_kernel;
close all

%% Perform the steps in the batch function

% instantiate the NeuralDecoder object
neurodec              = NeuralDecoder();
neurodec.spikeTrain   = spike_train;
neurodec.Fs           = 50;
neurodec.timestamps   = time;
neurodec.verbosity    = true;

% particle swarm configuration
options               = optimoptions('particleswarm');
options.Display       = 'off';
options.UseParallel   = true;

% cost function should take only one argument, a vector of parameters
fun = @(params) neurodec.optimize_EMG_kernel(raw_signal, params);
% lower bounds
lb = [0, 0, 0, 0];
% upper bounds
ub = [100, 100, 100, 100];

% perform particle swarm optimization
[new_params, fval, exitflag, output] = particleswarm(fun, 4, lb, ub, options);

%% Compare old and new parameters

disp(['Old parameters: ' mat2str(params)])
disp(['New parameters: ' mat2str(new_params)])
