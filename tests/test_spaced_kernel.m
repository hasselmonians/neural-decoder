%% test_spaced_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.

%% Generate the true data

options = generateSampleData();
[firing_rate_estimate, neurodec, options] = generateSampleData(options);

%% Sample the parameters

% determine the number of simulations
nSamples = 19;

% create a matrix of integral exponents
exponents = linspace(-4, 4, nSamples);
exp_matrix = permn(exponents, 2);
nSims = length(exp_matrix);

% create an input vector
these_params = NaN(nSims, 4);

% tile a log-spaced domain in terms of mu and tau
% only explore two parameters (ignore alpha and sigma)
these_params(:, 1) = options.Params(1); % alpha
these_params(:, 2) = options.Params(2) .^ exp_matrix(:, 1); % mu
these_params(:, 3) = options.Params(3); % sigma
these_params(:, 4) = options.Params(4) .^ exp_matrix(:, 2); % tau

% output variables
cost = NaN(nSims, 1);
logL = NaN(nSims, 1);

%% Main loop

for ii = 1:nSims
  corelib.textbar(ii, nSims)
  [cost(ii), logL(ii)] = objective(neurodec, options.Signal, these_params(ii, :));
end

%% Output

alpha   = these_params(:, 1);
mu      = these_params(:, 2);
sigma   = these_params(:, 3);
tau     = these_params(:, 4);

data_table = table(alpha, mu, sigma, tau, logL, cost);
