function batchFunction(index, location, batchname, outfile, test)

  %% Preamble

  if nargin < 4
    test = false;
  end

  % if test is false, do not add to the matlab path
  if ~test
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/RatCatcher/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/srinivas.gs_mtools'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/CMBHOME/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/neural-decoder/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/ex-gaussian/'))
    % addpath(genpath('/projectnb/hasselmogrp/ahoyland/NLID-matlab-wrapper/'))
    import CMBHOME.*
  end

  %% Read data

  [filename, cellnum] = RatCatcher.read(index, location, batchname);

  %% Load data

  % load the root object from the specified raw data file
  load(filename);
  root.cel    = cellnum;
  root        = root.AppendKalmanVel;
  speed       = root.svel;

  %% Generate the Neural Decoder object

  neurodec    = NeuralDecoder(root);
  neurodec.bandwidth = 60; % s

  %% Instantiate the nldat object

  iodata = nldat([speed(:), firing_rate_estimate(:)], ...
    'domainincr', 1 / neurodec.Fs, ...
    'domainvalues', neurodec.timestamps, ...
    'domainname', 'Time', ...
    'chanunits', {'cm/s', 'Hz'}, ...
    'channames', {'running speed', 'firing rate'});

  %% Compute the impulse response function
  % using the pseudo-inverse IRF approximation algorithm
  % Westwick & Kearney 2003, Ch. 5

  nLags = neurodec.bandwidth * neurodec.Fs;
  h = irf(iodata, 'nlags', nLags, 'mode', 'auto');

  %% Save the data

  writematrix(h, outfile);

end % function
