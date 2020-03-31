%% test_adaptive_kernel.m
% Use a test signal and known kernel parameters.
% Sample many parameters and compute the log likelihood
% as defined by the cost function.
% TODO: debug this

%% Generate the true data

options = generateSampleData();
[firing_rate_estimate, neurodec, signal] = generateSampleData(options);

%% Sample the parameters

a = adaptive();
a.MaxIter = 20;
a.Lower = [0, 0];
a.Upper = [100, 100];
a.SampleFcn = @(params) neurodec.objective_function(signal, params);

%% Output

% generate a figure
figure('outerposition',[300 300 601 600],'PaperUnits','points','PaperSize',[601 600]); hold on
a.PlotHere = gca;

figlib.pretty('LineWidth',1)

xlabel('\sigma')
ylabel('\tau')
c = colorbar;
c.Label.String = 'objective';

% perform the sampling and plot onto the created figure
a.sample();
