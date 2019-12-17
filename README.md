# neural-decoder
Produces a model of the relationship between an extrinsic observable signal and an intrinsic covarying spike train

## Dependencies

You will need

* [RatCatcher](https://github.com/hasselmonians/RatCatcher)
* [BandwidthEstimator](https://github.com/hasselmonians/BandwidthEstimator)
* [mtools](https://github.com/sg-s/srinivas.gs_mtools)

## Step 1: Collect the raw data

The raw data is in the form of `CMBHOME.Session` objects.
These can be loaded into `BandwidthEstimator` objects
to extract the spike train.

The data tables which contain the post-processed datasets
can be found at:

```
scc1.bu.edu:/projectnb/hasselmogrp/ahoyland/data/holger/Holger-BandwidthEstimator.mat
scc1.bu.edu:/projectnb/hasselmogrp/ahoyland/data/caitlin/Caitlin-BandwidthEstimator.mat
```

The raw data files can be loaded from the filenames and filecodes.

```matlab
[best, root] = RatCatcher.extract(dataTable, index, 'BandwidthEstimator', @(x) strrep(x, 'projectnb', 'mnt'));
```

## Step 2: Extract the signals

Neither the bandwidth parameter nor the firing rate estimate is necessary
for this analysis.
Instead, it is important to acquire the spike train and extrinsic biological signals.

* The spike train exists in the `best.spikeTrain` property.
* The animal running speed can be found in the `root.svel` property.
* The head direction can be found in the `root.headdir` property.

## Step 3: Fit a transformation to the biological signal

The model assumes that the spike train is encoding information found in the biological signal.
First, the biological signal is encoded in a latent time-varying signal.
Then, the cell emits spikes stochastically,
according to a Poisson process.

We assume that the transformation from the biological signal to the
latent time-varying signal can be written as a convolution.
We convolve the biological signal with an exponentially-modified Gaussian kernel.
Then, we treat this signal as the rate of a non-homogeneous Poisson process
and generate a spike train.

We maximize the log-likelihood of the Poisson process
in order to indirectly optimize the kernel parameters.
