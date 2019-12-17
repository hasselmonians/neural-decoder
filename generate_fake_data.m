% generate fake Poisson-distributed data based on a non-homogeneous rate parameter
% generate the non-homogeneous rate parameter by convolving a known signal
% with an exponentially-modified Gaussian kernel
%
% Arguments:
%   % raw_signal: a time-varying rate used to generate the Poisson-distributed spike train
%   % kernel: the vector to convolve the raw signal with
%
% Outputs:
%   spike_train: the spike-train generated by the Poisson process
%   transformed_signal: the rate used as a time-varying parameter of the Poisson process

function [spike_train, transformed_signal] = generate_fake_data(raw_signal, kernel)

  transformed_signal = conv(raw_signal, kernel, 'same');
  spike_train = poissrnd(transformed_signal);

end % function
