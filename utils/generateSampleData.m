function varargout = generateSampleData(varargin)

  % [options] = generateSampleData();
  % [firing_rate_estimate, neurodec] = generateSampleData('Name', value, 'Name', value, ...);

  % generates a neural decoder object,
  % a kernel, and an encoded signal

  % instantiate options
  options = struct;
  options.dt = 1 / 30;
  options.Timestamps = 0:options.dt:100;
  options.Bandwidth = 60;
  options.Verbosity = true;
  signal = 5 * rectpuls(options.Timestamps - options.Timestamps(1) - 50, 0.5/options.dt);
  options.Signal = signal;
  options.Params = [5, 10, 3, 10];

  if nargout==1 && ~nargin
    varargout{1} = options;
    return
  end

  % validate options
  options = corelib.parseNameValueArguments(options, varargin{:});

  %% Instantiate a NeuralDecoder object

  corelib.verb(options.Verbosity, 'NeuralDecoder/generateSampleData', 'instantiating a NeuralDecoder object')

  neurodec = NeuralDecoder();
  neurodec.Fs = 1 / options.dt;
  neurodec.bandwidth = options.Bandwidth;
  neurodec.timestamps = options.Timestamps;
  neurodec.verbosity = options.Verbosity;

  %% Generate a known kernel

  corelib.verb(options.Verbosity, 'NeuralDecoder/generateSampleData', 'generating a known kernel')

  w = neurodec.getKernelSupport();
  neurodec.kernel = exgauss_kernel(w, options.Params);

  % truncate the kernel to an arbitrary cutoff, then renormalize
  % this is to make the convolutions faster
  neurodec.kernel = options.Params(1) * truncate_kernel(neurodec.kernel, 'Cutoff', 0.01, 'Normalize', true, 'Verbosity', options.Verbosity);

  %% Perform the encoding

  corelib.verb(options.Verbosity, 'NeuralDecoder/generateSampleData', 'performing the encoding')

  % convolve the signal and the kernel. snip to correct size
  firing_rate_estimate = neurodec.encode(options.Signal, neurodec.kernel);
  % prevent zeros from appearing in the firing rate estimate
  firing_rate_estimate(firing_rate_estimate < eps) = eps;

  % generate a spike train from the firing rate estimate
  neurodec.spikeTrain = poissrnd(firing_rate_estimate * options.dt);

  %% Outputs

  varargout{1} = firing_rate_estimate;
  varargout{2} = neurodec;
  varargout{3} = options.Signal;
