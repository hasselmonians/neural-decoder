function init(isCluster)

    % sets the MATLAB path for the neural-decoder project

    if ~exist('isCluster', 'var')
        isCluster = false;
    end

    % e.g. ~/code
    code_dir = pathlib.strip(mfilename('fullpath'), 3);

    if isCluster
        addpath /projectnb/hasselmogrp/ahoyland/scripts
        addpath /projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools
        addpath /projectnb/hasselmogrp/ahoyland/ex-gaussian
        addpath /projectnb/hasselmogrp/ahoyland/neural-decoder
        addpath /projectnb/hasselmogrp/ahoyland/neural-decoder/utils
        addpath /projectnb/hasselmogrp/ahoyland/RatCatcher
        addpath /projectnb/hasselmogrp/ahoyland/RatCatcher/scripts
        addpath /projectnb/hasselmogrp/ahoyland/CMBHOME
    else
        addpath(code_dir)
        addpath(fullfile(code_dir, 'srinivas.gs_mtools'))
        addpath(fullfile(code_dir, 'ex-gaussian'))
        addpath(fullfile(code_dir, 'neural-decoder'))
        addpath(fullfile(code_dir, 'neural-decoder', 'utils'))
	addpath(fullfile(code_dir, 'RatCatcher'))
	addpath(fullfile(code_dir, 'RatCatcher', 'scripts'))
	addpath(fullfile(code_dir, 'CMBHOME'))
    end
