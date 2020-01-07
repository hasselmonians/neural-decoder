% loglikelihood
% computes the log likelihood of a non-homogeneous Poisson process
% where transformed_signal is the Poisson rate
% and the Poisson process produces a given spike train
%
%% Arguments:
%   self: a NeuralDecoder object
%   transformed_signal: an estimate for the underlying firing rate
%     this is a vector probably computed by kconv
%
%% Outputs: the loglikelihood as a scalar
%
% See Also: NeuralDecoder.kernelCore, NeuralDecoder.cvKernel

function L = loglikelihood(self, transformed_signal)

  dt = 1 / self.Fs;

  L = sum( ...
    - transformed_signal * dt ...
    + self.spikeTrain .* log(transformed_signal) ...
    + self.spikeTrain * log(dt) ...
    - log(factorial(self.spikeTrain)));

end % function
