% Test a small batch for quality-control purposes.

% instantiate RatCatcher object
r 		= RatCatcher;
r.expID 	= {'Caitlin', 'A'};
r.remotepath 	= '/projectnb/hasselmogrp/ahoyland/neural-decoder/cluster/';
r.localpath 	= '/projectnb/hasselmogrp/ahoyland/neural-decoder/cluster/';
r.protocol 	= 'NeuralDecoder';
r.project 	= 'hasselmogrp';
r.verbose 	= 'true';

% batch files
r		= r.batchify();
