# neural-decoder
Produces a model of the relationship between an extrinsic observable signal and an intrinsic covarying spike train

## Dependencies

You will need

* [RatCatcher](https://github.com/hasselmonians/RatCatcher)
* [mtools](https://github.com/sg-s/srinivas.gs_mtools)
* [NLID-matlab-toolbox](https://github.com/pedroperrusi/NLID-matlab-toolbox)

## Step 1: Collect the raw data

The raw data is in the form of `CMBHOME.Session` objects.
These can be loaded into `NeuralDecoder` objects
to extract the spike train.

The data tables which contain the post-processed datasets
can be found at:

```
scc1.bu.edu:/projectnb/hasselmogrp/ahoyland/data/holger/Holger-BandwidthEstimator.mat
scc1.bu.edu:/projectnb/hasselmogrp/ahoyland/data/caitlin/Caitlin-BandwidthEstimator.mat
```

The raw data files can be loaded from the filenames and filecodes.

```matlab
[neurodec, root] = RatCatcher.extract(dataTable, index, 'NeuralDecoder', @(x) strrep(x, 'projectnb', 'mnt'));
```

## Step 2: Extract the signals

Neither the bandwidth parameter nor the firing rate estimate is necessary
for this analysis.
Instead, it is important to acquire the spike train and extrinsic biological signals.

* The spike train exists in the `neurodec.spikeTrain` property.
* The animal running speed can be found in the `root.svel` property.
* The head direction can be found in the `root.headdir` property.

## Step 3: Fit a transformation to the biological signal

The model assumes that the spike train is encoding information found in the biological signal.
First, the biological signal is encoded in a latent time-varying signal.
Then, the cell emits spikes stochastically,
according to a Poisson process.

We assume that the transformation from the biological signal to the
latent time-varying signal can be written as a convolution of an impulse response function
and the biological signal.

The latent time-varying signal is estimated by producing a firing rate estimate from the spike train.
We compute the firing rate estimate by kernel smoothing, choosing the bandwidth
by maximizing the cross-validated log-likelihood that the computed firing rate estimate
is the inhomogeneous rate parameter of the Poisson process that generated the known spike train
(Prerau & Eden 2011, Dannenberg *et al.* 2019).

We estimate the impulse response function of the cell through a pseudo-inverse based algorithm
(Westwick & Kearney 2003, Ch. 5).
This method produces a much less noisy estimate without introducing too much bias.

1. Estimate the autocorrelation and cross-correlation of the input and input-output.
2. Compute an initial estimate of the IRF
by estimating the Hessian from the autocorrelation coefficients.
The initial estimate is the inverse of the Hessian times the cross-correlation.
3. Compute the singular value decomposition (SVD) of the Hessian
and calculate the output variance contributed by each singular value
and its corresponding singular vector. Sort in decreasing order.
4. Calculate the minimum description length (MDL) cost function for all model parameters M = 1, 2, ... .
5. Choose the value of M that minimizes the MDL
and retain only the M most significant terms for the final IRF estimate.
