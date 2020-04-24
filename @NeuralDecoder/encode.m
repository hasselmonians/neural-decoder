
function [transformed_signal] = encode(self, raw_signal)

  %% Description
  %   generate Poisson-distributed data based on a non-homogeneous rate parameter
  %   generate the non-homogeneous rate parameter by convolving a known signal
  %   with an exponentially-modified Gaussian kernel
  %
  %% Arguments:
  %   % raw_signal: a time-varying rate used to generate the Poisson-distributed spike train
  %
  %% Outputs:
  %   transformed_signal: the rate used as a time-varying parameter of the Poisson process

  % generate the transformed signal by taking the convolution
  transformed_signal = conv(raw_signal, self.kernel, 'full');
  % truncate the signal to the same size as the raw signal
  transformed_signal = transformed_signal(1:length(raw_signal));

end % function
