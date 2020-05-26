function [raw_signal, neurodec, root] = generateRawData(isCluster)

    %% Description:
    %   Load actual raw data for use in testing.
    %
    %% Arguments:
    %   isCluster: logical scalar, determines whether to preprocess filepaths
    %
    %% Outputs:
    %   raw_signal: numerical vector, the raw signal (usually running speed)
    %   neurodec: 1x1 NeuralDecoder object
    %   root: 1x1 CMBHOME.Session object
    %
    %% Examples:
    %
    %   [raw_signal] = generateRawData()
    %
    %   [~, neurodec, root] = generateRawData()
    %
    % See Also: generateFakeData, generateSampleData, RatCatcher/extract

    %% Preamble

    if ~exist('isCluster', 'var') || isempty(isCluster)
        isCluster = false;
    end

    if isCluster
        preprocess_fcn = [];
    else
        preprocess_fcn = @(x) strrep(x, 'projectnb', 'mnt');
    end

    %% Instantiate a RatCatcher object

    run_Holger;
    r = r.validate;

    %% Extract the data from the cluster

    [neurodec, root] = RatCatcher.extract(r, ...
        'Protocol', 'NeuralDecoder', ...
        'Index', 1, ...
        'PreProcessFcn', preprocess_fcn, ...
        'Verbosity', true);

    raw_signal = root.svel;

end % function
