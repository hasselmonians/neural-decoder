%% test_spaced_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.

%% Generate the true data

options = generateSampleData();
[firing_rate_estimate, neurodec, signal] = generateSampleData(options);

%% Sample the parameters

% determine the number of simulations
nSamples = 5;

% create a matrix of integral exponents
exponents = linspace(-2, 2, nSamples);
these_combinations = nchoosek(nSamples, 2);
nSims = length(these_combinations);

% create an input vector
these_params = NaN(nSims, 4);

% only examine two parameters (ignore alpha and mu)
these_params(:, 1) = options.Params(1);
these_params(:, 2) = options.Params(2);

% tile a log-spaced domain in terms of Params(3) and Params(4)
these_params(:, 3) = options.Params(3) ^ exps(these_combinations(:, 1));
these_params(:, 3) = options.Params(4) ^ exps(these_combinations(:, 2));

% output variables
objective = NaN(nSims, 1);
logL = NaN(nSims, 1);

%% Main loop

for ii = 1:nSims
  corelib.textbar(ii, nSims)
  [objective(ii), logL(ii)] = objective_function(neurodec, signal, these_params(ii, :));
end

%% Output

alpha   = these_params(:, 1);
mu      = these_params(:, 2);
sigma   = these_params(:, 3);
tau     = these_params(:, 4);

data_table = table(alpha, mu, sigma, tau, logL, objective);
