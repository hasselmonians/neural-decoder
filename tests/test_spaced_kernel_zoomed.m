%% test_spaced_kernel_zoomed.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.
% Sample according to a logarithmically spaced grid.

% path to where data should be saved
data_path = fullfile(pathlib.strip(mfilename('fullpath'), 2), 'data', 'test_spaced_kernel_zoomed.mat');

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

%% Perform the encoding

% check to see if file exists
if exist(data_path, 'file')
  % data file exists, load the data file and don't do expensive computations
  corelib.verb(true, 'neural-decoder/test_spaced_kernel_zoomed', 'data file found, loading...')
  load(data_path)
else
  % data file doesn't exist, performing expensive computations
  corelib.verb(true, 'neural-decoder/test_spaced_kernel_zoomed', 'data file not found, performing computations...')

  %% Generate the true data

  [firing_rate_estimate, neurodec, options] = generateSampleData(options);

  %% Sample the parameters

  % determine the number of simulations
  nSamples = 19;

  % create a matrix of integral exponents
  exponents = linspace(-1, 1, 13);
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

  %% Save output to file

  corelib.verb(true, 'neural-decoder/test_spaced_kernel_zoomed', ['saving data file to: ' data_path])
  save(data_path, 'data_table');
end % if/else

%% Visualize

% runs where the cost is too high are invalid
data_table.cost(data_table.cost >= 1e9) = NaN;

% plot a heatmap
heatmap(data_table, 'mu', 'tau', 'ColorVariable', 'cost');

%% Test

[~, B] = min(data_table.cost);

disp('Parameters used to generate the data:')
disp(options.Params)

disp('Parameters which maximize the log-likelihood:')
disp(data_table(B, :))
