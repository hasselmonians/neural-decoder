% Test gathering NeuralDecoder protocol data from the cluster.
% First run `test_batch.m` then `qsub` the jobs on the cluster.
% Then run this script.

% gather files
data_table = r.gather();
data_table = r.stitch(data_table);

% save
data_dir = fullfile(pathlib.strip(mfilename('fullpath'), 3), 'data');
save(fullfile(data_dir, test-NeuralDecoder.mat', 'data_table', 'r');
