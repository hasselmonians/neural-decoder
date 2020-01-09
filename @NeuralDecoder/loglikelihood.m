% loglikelihood
% computes the log likelihood of a non-homogeneous Poisson process
% where rate is the Poisson rate
% and the Poisson process produces a given spike train
%
%% Arguments:
%   self: a NeuralDecoder object
%   rate: an estimate for the underlying firing rate
%     this is a vector probably computed by kconv
%
%% Outputs:
%   L: the loglikelihood as a scalar
%
% See Also: NeuralDecoder.kernelCore, NeuralDecoder.cvKernel

function L = loglikelihood(self, rate)

  dt = 1 / self.Fs;

  L = sum( ...
    - rate * dt ...
    + self.spikeTrain .* log(rate) ...
    + self.spikeTrain * log(dt) ...
    - log(factorial(self.spikeTrain)));

end % function
