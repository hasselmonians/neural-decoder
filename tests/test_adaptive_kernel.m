%% test_rand_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.

%% Generate the true data

options = generateSampleData();
[firing_rate_estimate, neurodec, signal] = generateSampleData(options);

%% Sample the parameters

a = adaptive();
a.MaxIter = 20;
a.Lower = [0, 0];
a.Upper = [100, 100];
a.SampleFcn = @(params) neurodec.objective_function(signal, params);

% %% Output
%
% alpha   = rand_params(:, 1);
% mu      = rand_params(:, 2);
% sigma   = rand_params(:, 3);
% tau     = rand_params(:, 4);
%
% data_table = table(alpha, mu, sigma, tau, logL, objective);
