classdef NeuralDecoder

properties

  spikeTrain  % the spike train in time-steps
  spikeTimes  % the spike times in seconds
  Fs          % the sample frequency in Hz
  timestamps  % the time steps in seconds of the spike train
  bandwidth   % the bandwidth of the kernel
  kernel      % the kernel
  verbosity   % whether to provide textual output

end % properties

methods

  % constructor
  function self = NeuralDecoder(root)

    if nargin == 0
      return
    end

    self.timestamps   = root.ts;
    self.spikeTimes   = CMBHOME.Utils.ContinuizeEpochs(root.cel_ts);
    self.spikeTrain   = NeuralDecoder.getSpikeTrain(self.spikeTimes, self.timestamps);
    self.Fs           = root.fs_video;
    self.bandwidth    = 60;
    self.verbosity    = true;
  end % function

end % methods

methods (Static)

                            batchFunction(index, location, batchname, outfile, test);
  [transformed_signal]    = encode(raw_signal, kernel)
  [spikeTrain]            = getSpikeTrain(spikeTimes, timestamps)

end % static methods

end % classdef
