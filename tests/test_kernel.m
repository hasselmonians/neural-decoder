%% test script
% Test the kernel-generating function
% and plot many kernels.

%% Instantiate NeuralDecoder object

neurodec            = NeuralDecoder();
neurodec.Fs         = 50;               % Hz
neurodec.bandwidth  = 40;               % s
neurodec.verbosity  = true;

w = neurodec.getKernelSupport();

%% Generate a matrix of kernel parameters

% container for storing parameters
params = permn([0, 3, 10, 30], 3);
nKernels = length(params);

% tack on the alpha parameter, fixed to unity
params = [ones(nKernels, 1) params];

%% Compute the kernels

% container for storing kernels
k = NaN(length(w), nKernels);

% compute the kernels
for ii = 1:nKernels
    corelib.textbar(ii, nKernels);
    k(:, ii) = exgauss_kernel(w, params(ii, :));
end

%% Plot the kernels

figure; hold on;
l = colormaps.linspecer(nKernels);
for ii = 1:nKernels
    plot(w, k(:, ii), 'Color', l(ii, :));
end

title('a bunch of kernels')
xlabel('kernel support (s)')
ylabel('kernel density')
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1)

%% Show effect of mu with all other parameters constant

nKernels = 11;
mus = linspace(0, 30, nKernels);
params = zeros(nKernels, 4);
params(:, 1) = 1;
params(:, 3) = 5;
params(:, 4) = 3;
params(:, 2) = mus;

% compute the kernels
for ii = 1:nKernels
    corelib.textbar(ii, nKernels);
    k(:, ii) = exgauss_kernel(w, params(ii, :));
end

figure; hold on;
l = colormaps.linspecer(nKernels);
for ii = 1:nKernels
    plot(w, k(:, ii), 'Color', l(ii, :));
end

title('a bunch of kernels')
xlabel('kernel support (s)')
ylabel('kernel density')
figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1)
