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
    else
        addpath(code_dir)
        addpath(fullfile(code_dir, 'srinivas.gs_mtools'))
        addpath(fullfile(code_dir, 'ex-gaussian'))
        addpath(fullfile(code_dir, 'neural-decoder'))
        addpath(fullfile(code_dir, 'neural-decoder', 'utils'))
    end
