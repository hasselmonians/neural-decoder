function kernel_support = getKernelSupport(self, kernel)

  % computes the time-axis for the kernel
  % from the bandwidth and sampling frequency

  if nargin < 2
    kernel_support = colon(0, 1 / self.Fs, self.bandwidth);
  else
    kernel_support = 1 / self.Fs * colon(0, 1, kernel);
  end

end % function
