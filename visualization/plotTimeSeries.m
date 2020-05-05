function f = plotTimeSeries(data_table, index, varargin)

    %% Description:
    %   Creates a plot of the kernel, the speed trace,
    %   and the firing rate estimate.
    %
    %% Arguments:
    %   data_table: a table created by the NeuralDecoder protocol into RatCatcher
    %   index: linear index into the first dimension of the data table
    %   varargin:
    %       either a struct of options
    %       or name-value argument pairs
    %
    %% Outputs:
    %   handle to the figure
    %
    %% See Also: RatCatcher/extract

    %% Preamble

    options = struct;
    options.Verbosity = true; % true or false
    options.PreProcessFcn = []; % either empty or a function handle
    options.PlotHere = []; % figure handle

    options = orderfields(options);

    if ~nargin & nargout
        varargout{1} = options;
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    %% Extract data from the data table

    [neurodec, root] = RatCatcher.extract(data_table, ...
        'Index', index, ...
        'Protocol', 'NeuralDecoder', ...
        'PreProcessFcn', options.PreProcessFcn, ...
        'Verbosity', options.Verbosity);

    %% Plot it

    if ~exist(options.PlotHere) || isempty(options.PlotHere)
        f = figure;
    else
        f = options.PlotHere;
    end

    % compute the kernel using the parameters
    w = neurodec.getKernelSupport();
    params = data_table{index, {'alpha', 'mu', 'sigma', 'tau'}};
    neurodec.kernel = params(1) * truncate_kernel(exgauss_kernel(w, params), ...
      'Cutoff', 0.01, ...
      'Normalize', true, ...
      'Verbosity', options.Verbosity);

    % plot the kernel
    % ax(1) = subplot(f, 3, 1, 1);

    % plot the speed trace

    % plot the firing rate trace
