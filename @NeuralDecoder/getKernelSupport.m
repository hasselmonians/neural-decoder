function kernel_support = getKernelSupport(self)

  % computes the time-axis for the kernel
  % from the bandwidth and sampling frequency

  kernel_support = colon(0, 1 / self.Fs, self.bandwidth);

end % function
