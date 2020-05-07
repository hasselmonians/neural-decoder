%% run_Caitlin.m
% Run RatCatcher's NeuralDecoder protocol over
% Caitlin Monaghan's 2018 dataset,
% filtering first for linearly speed modulated cells with well-defined firing rates.
% See Dannenberg et al. 2019 and
% https://github.com/hasselmonians/MLE-time-course
% for details.

%% Instantiate the RatCatcher object
r               = RatCatcher;
r.expID         = 'Caitlin-SM';
r.remotepath    = '/projectnb/hasselmogrp/ahoyland/neural-decoder/cluster';
r.localpath     = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster';
r.protocol      = 'NeuralDecoder';
r.project       = 'hasselmogrp';
r.verbose       = true;

%% Load the post-processed BandwidthEstimator analysis on Caitlin's data

corelib.verb(r.verbose, 'run_Caitlin', 'trying to load post-processed BandwidthEstimator data')

try
    % if the cluster is mounted locally
    load /mnt/hasselmogrp/ahoyland/data/caitlin/data-Caitlin-BandwidthEstimator-processed.mat
    corelib.verb(r.verbose, 'run_Caitlin', 'successfully loaded data using local path')
catch
    % if on the cluster
    load /projectnb/hasselmogrp/ahoyland/data/caitlin/data-Caitlin-BandwidthEstimator-processed.mat
    corelib.verb(r.verbose, 'run_Caitlin', 'successfully loaded data using remote path')
end

% filter the dataset
modulated   = corelib.vectorise(dataTable.Pearson >= 0.0795);
% linear      = corelib.vectorise([dataTable.stats.p] >= 0.05);
% passing     = corelib.vectorise(dataTable.kmax / 30 < 10);

% add filenames and filecodes to RatCatcher object
r.filenames = dataTable.filenames(modulated, :);
r.filecodes = dataTable.filecodes(modulated, :);

return

r = r.batchify();
