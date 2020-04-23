% loglikelihood
% computes the log likelihood of a non-homogeneous Poisson process
% where rate is the Poisson rate
% and the Poisson process produces a given spike train
%
%% Arguments:
%   self: a NeuralDecoder object
%   rate: a positive, real numerical vector,
%     an estimate for the underlying firing rate,
%     probably computed by NeuralDecoder.encode
%
%% Outputs:
%   L: the loglikelihood as a scalar
%
% See Also: NeuralDecoder.encode, NeuralDecoder.objective

function L = loglikelihood(self, rate)

  % check to make sure the rate is real
  assert(all(isreal(rate)), 'rate must be a vector of positive, real numbers');

  % check to make sure that the rate is nonzero everywhere
  % this prevents log(0) errors
  if any(rate == 0)
    corelib.verb(self.verbosity, 'NeuralDecoder::loglikelihood', ...
      'rate is zero somewhere, setting to ''eps''')
    rate(rate == 0) = eps;
  end

  dt = 1 / self.Fs;

  L = sum( ...
    - rate * dt ...
    + self.spikeTrain .* log(rate) ...
    + self.spikeTrain * log(dt) ...
    - log(factorial(self.spikeTrain)));

end % function
