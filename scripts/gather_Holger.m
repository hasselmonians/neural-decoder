run_Holger

r = r.validate;
data_table = r.gather;
data_table = r.stitch(data_table);

save_path = fullfile(pathlib.strip(mfilename('fullpath'), 2), 'data', [r.batchname '.mat']);
disp(['saving data to ' save_path])
save(save_path, 'data_table', 'r')
