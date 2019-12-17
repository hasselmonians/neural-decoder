% create an exgaussian kernel

function k = exgauss_kernel(bandwidth, params, notch)

  k = exgauss_pdf(bandwidth, mu, sigma, tau);

  if ~exist('notch', 'var') || ~notch
    % do nothing
  else
    % notch the kernel at t = 0
    k(1) = 0;
    k = k / sum(k);
  end

end % function
