% create an exgaussian kernel

function k = exgauss_kernel(bandwidth, params, notch)

  k = params(1) * exgauss_pdf(bandwidth, params(2), params(3), params(4));

  if ~exist('notch', 'var') || ~notch
    % do nothing
  else
    % notch the kernel at t = 0
    k(1) = 0;
    k = params(1) * k / sum(k);
  end

end % function
