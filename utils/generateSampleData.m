function varargout = generateSampleData(varargin)

  %% Description
  %   Generates a NeuralDecoder object, a kernel, and an encoded signal.
  %
  %% Arguments:
  %   options: a struct of options, or name-value pairs
  %     Bandwidth: numerical scalar, length of kernel, default: XX
  %     dt: numerical scalar, the time-step, default: XX
  %     Params: numerical vector, 1x4 vector containing [alpha, mu, sigma, tau] parameters
  %     Signal: numerical vector, signal to be encoded, default: XX
  %     Timestamps: numerical vector, vector of time stamps, default: XX
  %     Verbosity: logical scalar, print info text, default: XX
  %
  %% Outputs:
  %   firing_rate_estimate: numerical vector, the signal encoded by transformation with the kernel
  %   neurodec: NeuralDecoder object
  %   options: the structure containing the parsed options
  %
  %% Examples
  %   [options] = generateSampleData();
  %   [firing_rate_estimate, neurodec, options] = generateSampleData();
  %   [firing_rate_estimate, neurodec, options] = generateSampleData(options);
  %   [firing_rate_estimate, neurodec, options] = generateSampleData('Name', value, 'Name', value, ...);
  %
  %% See Also: generateRawData

  %% Preamble

  % instantiate options
  options             = struct;
  options.Bandwidth   = 40;
  options.dt          = 1 / 50;
  options.Params      = [0.2, 10, sqrt(3), 10];
  options.Signal      = generateFakeData();
  options.Timestamps  = 0:options.dt:300;
  options.Verbosity   = true;

  % if no arguments and one output, output options structure
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

  % truncate the kernel to an arbitrary cutoff, then renormalize
  % this is to make the convolutions faster
  w = neurodec.getKernelSupport();
  neurodec.kernel = options.Params(1) * truncate_kernel(exgauss_kernel(w, options.Params, true), ...
    'Cutoff', 0.01, ...
    'Normalize', true, ...
    'Verbosity', options.Verbosity);

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
  varargout{3} = options;
