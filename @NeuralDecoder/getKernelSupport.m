function kernel_support = getKernelSupport(self, kernel)

  %% Description:
  %   computes the time-axis for the kernel
  %
  %% Arguments:
  %   self: a NeuralDecoder object
  %   kernel: either a positive scalar or a vector
  %
  %% Outputs:
  %   kernel_support: vector, the support of the kernel
  %
  %% Examples:
  %   kernel_support = neurodec.getKernelSupport()
  %   kernel_support = neurodec.getKernelSupport(kernel)
  %
  %% See Also: NeuralDecoder

  if ~exist('kernel', 'var') || isempty(kernel)
    if isempty(self.kernel)
      % default to using the bandwidth
      assert(~isempty(self.bandwidth), 'Bandwidth cannot be empty if kernel is not specified');
      kernel_support = colon(0, 1 / self.Fs, self.bandwidth);
    else
      % use the kernel property
      kernel_support = 1 / self.Fs * colon(0, 1, length(self.kernel)-1);
    end
  else
    % use the specified second argument
    kernel_support = 1 / self.Fs * colon(0, 1, length(kernel)-1);
  end

end % function
