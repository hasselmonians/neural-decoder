r = RatCatcher;

r.expID = {'Caitlin', 'A'; 'Caitlin', 'B'; 'Caitlin', 'C'; 'Caitlin', 'D'; 'Caitlin', 'E'; 'Caitlin', 'F'};
r.remotepath = '/projectnb/hasselmogrp/ahoyland/neural-decoder/cluster/';
r.localpath = '/mnt/hasselmogrp/ahoyland/neural-decoder/cluster/';
r.protocol = 'NeuralDecoder';
r.project = 'hasselmogrp';
r.verbose = true;

return

% batch files
r = r.batchify;

% NOTE: run the 'qsub' command on the cluster now (see output in MATLAB command prompt)

return

% NOTE: once the cluster finishes, run the following commands

% gather files
r = r.validate;
dataTable = r.gather;
save('data/Caitlin-NeuralDecoder.mat', 'dataTable', 'r')
% dataTable = r.stitch(dataTable);
