function varargout = plotAll(data_table, indices, varargin)

    %% Description:
    %   Creates a plot of the kernel, the speed trace,
    %   and the firing rate estimate
    %   for all indices, then saves the figures as .eps files.
    %
    %% Arguments:
    %   data_table: a table created by the NeuralDecoder protocol into RatCatcher
    %   indices: linear index into the first dimension of the data table
    %   varargin:
    %       either a struct of options
    %       or name-value argument pairs
    %
    %% Outputs:
    %   handle to the figure
    %
    %% Examples:
    %
    %   options = plotTimeSeries()
    %
    %   h = plotTimeSeries(data_table, index, options)
    %
    %   h = plotTimeSeries(data_table, index, 'Name', value, ...)
    %
    %% See Also: RatCatcher/extract, plotTimeSeries, figlib/saveall

    %% Preamble

    options = struct;
    options.Verbosity = true; % true or false
    options.PreProcessFcn = []; % either empty or a function handle

    % options for figlib.saveall()
    options.Format = 'eps';
    options.Location = '~/Desktop/';
    options.SaveName = 'auto';

    options = orderfields(options);

    if ~nargin & nargout
        varargout{1} = options;
        return
    end

    options = corelib.parseNameValueArguments(options, varargin{:});

    if isempty(indices)
        indices = 1:height(data_table);
    end

    %% Generate the figures

    warning('off')

    for ii = sort(indices)
        corelib.textbar(ii, max(indices))
        % generate the figure, maximize
        f = plotTimeSeries(data_table, ii, options);
        set(f, 'Units', 'Normalized');
        set(f, 'Position', [0 0 1 1]);
        % save the figure
        options.SaveName = ['fig-' num2str(ii)];
        figlib.saveall(options);
        close all
    end

    warning('on')
