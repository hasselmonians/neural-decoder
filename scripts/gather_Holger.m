run_Holger

r = r.validate;
data_table = r.gather;
data_table = r.stitch(data_table);

save(['../data/' r.batchname '.mat'], 'data_table', 'r')
