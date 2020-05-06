function varargout = plotTimeSeries(data_table, index, varargin)

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
    % options.PlotHere = []; % figure handle

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

    % if ~exist(options.PlotHere) || isempty(options.PlotHere)
    %     f = figure;
    % else
    %     f = options.PlotHere;
    % end

    figure('outerposition', [300 300 601 600], ...
        'PaperUnits', 'points', ...
        'PaperSize', [601 600]);
    hold on

    % compute the kernel using the parameters
    w = neurodec.getKernelSupport();
    params = data_table{index, {'alpha', 'mu', 'sigma', 'tau'}};
    neurodec.kernel = params(1) * truncate_kernel(exgauss_kernel(w, params), ...
      'Cutoff', 0.01, ...
      'Normalize', true, ...
      'Verbosity', options.Verbosity);

    % plot the kernel
    ax(1) = subplot(4, 1, 1);
    plot(neurodec.getKernelSupport(), neurodec.kernel, 'k');
    xlabel('time (s)')
    ylabel('kernel density')

    % plot the speed trace
    ax(2) = subplot(4, 1, 2);
    plot(neurodec.timestamps, root.svel, 'k');
    xlabel('time (s)')
    ylabel('running speed (cm/s)')

    % plot the transformed running speed
    ax(3) = subplot(4, 1, 3);
    plot(neurodec.timestamps, neurodec.encode(root.svel));
    xlabel('time (s)')
    ylabel('conv. signal (Hz)')

    % plot the spike train
    ax(4) = subplot(4, 1, 4);
    stem(neurodec.timestamps, neurodec.spikeTrain, ...
        'Marker', 'None', ...
        'Color', [0 0 0])
    xlabel('time (s)')
    ylabel('# spikes')

    figlib.pretty('PlotBuffer', 0.1, 'PlotLineWidth', 1);

end % function
