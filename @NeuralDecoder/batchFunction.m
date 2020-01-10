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
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/BandwidthEstimator/'))
    addpath(genpath('/projectnb/hasselmogrp/ahoyland/NLID-matlab-toolbox/'))
    import CMBHOME.*
  end

  %% Read data

  [filename, cellnum] = RatCatcher.read(index, location, batchname);

  %% Load data

  % load the root object from the specified raw data file
  load(filename);
  root.cel = cellnum;
  root = root.AppendKalmanVel;
  speed = root.svel;

  %% Generate the Neural Decoder object

  neurodec = NeuralDecoder(root);
  neurodec.bandwidth = 60; % s

  %% Generate a firing rate estimate

  best = BandwidthEstimator(root);
  best.parallel = false;
  best.range = 3:2:(neurodec.bandwidth * best.Fs);
  best.kernel = 'hanning';

  % perform bandwidth parameter estimation with MLE/CV
  [~, kmax] = best.cvKernel();

  % generate a firing rate estimate
  firing_rate_estimate = best.kconv(kmax);

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

  % nLags = ceil(neurodec.bandwidth * neurodec.Fs);
  h = (1 / neurodec.Fs) * double(irf(iodata, 'nlags', kmax, 'mode', 'auto'));

  %% Save the data

  save([outfile(1:end-3), 'mat'], 'h', 'kmax', 'speed', 'best', 'neurodec')

  % output = NaN(length(h), 2);
  % output(:, 1) = h(:);
  % output(1, 2) = kmax;
  %
  % writematrix(output, outfile);

end % function
