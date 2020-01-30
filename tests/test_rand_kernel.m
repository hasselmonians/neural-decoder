%% test_rand_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.

%% Generate the true data

[neurodec, firing_rate_estimate, signal] = generateSampleData();

%% Sample the parameters

% output variables
params = NaN(nSims, 4);
objective = NaN(nSims, 1);
logL = NaN(nSims, 1);

% useful variables
nSims = 100;
rand_params = randi(100, 100, 4);
w = neurodec.getKernelSupport();

for ii = 1:nSims
  [objective(ii), logL(ii)] = objective_function(neurodec, signal, rand_params(ii, :));
end

%% Output

alpha   = rand_params(:, 1);
mu      = rand_params(:, 2);
sigma   = rand_params(:, 3);
tau     = rand_params(:, 4);

data_table = table(alpha, mu, sigma, logL, objective);
