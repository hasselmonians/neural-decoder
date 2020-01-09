
function [objective, logL, kernel, transformed_signal] = objective_function(self, signal, params)
  %%%
  % returns the log-likelihood that a given rate function generated a given spike train
  % the rate function is generated by convolving a known extrinsic biological signal
  % with an exponentially-modified Gaussian (EMG/exGaussian) kernel
  %
  % Arguments:
  %   self: the NeuralDecoder object
  %   signal: the extrinsic signal (e.g. the running speed of the animal)
  %   params: a 4x1 or 1x4 vector of parameters (alpha, mu, sigma, tau)
  %     corresponding to the parameters of a scaled EMG kernel
  % Outputs:
  %   objective: the scalar value returned by the objective function
  %   logL: the log-likelihood
  %   kernel: the kernel/impulse response function
  %   transformed signal: the raw signal convolved with the kernel

  %% Produce an exponentially-modified Gaussian kernel

  % x-axis for kernel
  w = self.getKernelSupport();

  % generate the kernel
  kernel = exgauss_kernel(w, params);

  % truncate the kernel
  kernel = truncate_kernel(kernel, 'Cutoff', 0.01, 'Normalize', true);

  %% Perform a convolution of the kernel with the signal

  % perform the convolution
  transformed_signal = NeuralDecoder.encode(signal, kernel);

  % penalize returning NaNs
  if any(isnan(transformed_signal))
    objective = 1e12;
    return
  end

  % fix log(0) problem
  transformed_signal(transformed_signal < 1e-5) = 1e-5;

  %% Compute the log-likelihood
  % of the transformed signal producing the given spike train

  logL = self.loglikelihood(transformed_signal);

  if logL <= 0
    objective = abs(logL) + 1;
  else
    objective = 1 / logL;
  end

end % objective_function
