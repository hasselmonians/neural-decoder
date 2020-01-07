function iodata = nldat(self, u, z)

  % produces an nldat object (see NLID-matlab-toolbox)
  % from the raw data stored in the NeuralDecoder object

  % Arguments:
  %   self: the NeuralDecoder object
  %   u: the signal (viz. running speed, head direction) as a vector of doubles
  %   z: the response (viz. firing rate) as a vector of doubles

  iodata = nldat([u,z], ...
    'domainincr', 1/self.Fs, ...
    'domainvalues', self.timestamps, ...
    'domainname', 'Time',...
    'chanunits', { 'a.u.', 'Hz'}, ...
    'channames', { 'extrinsic signal', 'firing rate'});

end % function
