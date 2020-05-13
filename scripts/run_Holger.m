%% run_Holger.m
% Run RatCatcher's NeuralDecoder protocol over
% Holger Dannenberg's 2019 dataset,
% filtering first for linearly speed modulated cells with well-defined firing rates.
% See Dannenberg et al. 2019 and
% https://github.com/hasselmonians/MLE-time-course
% for details.

%% Instantiate the RatCatcher object
r               = RatCatcher;
r.expID         = 'Holger-SM';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/neural-decoder/cluster';
r.localpath     = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster';
r.protocol      = 'NeuralDecoder';
r.project       = 'hasselmogrp';
r.verbose       = true;

%% Load the filenames and filecodes from Holger's 2019 dataset

corelib.verb(r.verbose, 'run_Holger', 'trying to load post-processed BandwidthEstimator data...')

try
    % if the cluster is mounted locally
    load /mnt/hasselmogrp/ahoyland/data/holger/speed-modulation/filenames_speed_modulated.mat
    corelib.verb(r.verbose, 'run_Holger', 'successfully loaded data using local path')
catch
    % if on the cluster
    corelib.verb(r.verbose, 'run_Holger', 'failed to load using local paths, trying with remote paths...')
    load /projectnb/hasselmogrp/ahoyland/data/holger/speed-modulation/filenames_speed_modulated.mat
    corelib.verb(r.verbose, 'run_Holger', 'successfully loaded data using remote path')
end

% add filenames and filecodes to RatCatcher object
r.filenames = filenames(end-91:end);
r.filecodes = filecodes(end-91:end, :);

return

r = r.batchify();
