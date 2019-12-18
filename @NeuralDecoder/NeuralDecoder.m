classdef NeuralDecoder

properties

  spikeTrain  % the spike train in time-steps
  spikeTimes  % the spike times in seconds
  Fs          % the sample frequency in Hz
  timestamps  % the time steps in seconds
  verbosity   % whether to provide textual output

end % properties

methods

  % constructor
  function self = NeuralDecoder(root)
    self.timestamps   = root.ts;
    self.spikeTimes   = CMBHOME.Utils.ContinuizeEpochs(root.cel_ts);
    self.spikeTrain   = NeuralDecoder.getSpikeTrain(self.spikeTimes, self.timestamps);
    self.Fs           = root.fs_video;
    self.verbosity    = true;
  end % function

end % methods

methods (Static)

                            batchFunction(index, location, batchname, outfile, test);
  [transformed_signal]    = encode(raw_signal, kernel)
  [spikeTrain]            = getSpikeTrain(spikeTimes, timestamps)

end % static methods

end % classdef
