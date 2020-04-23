# neural-decoder
Produces a model of the relationship between an extrinsic observable signal and an intrinsic covarying spike train

## Dependencies

You will need

* [RatCatcher](https://github.com/hasselmonians/RatCatcher)
* [mtools](https://github.com/sg-s/srinivas.gs_mtools)
* [ex-gaussian](https://github.com/hasselmonians/ex-gaussian)

## Description of the model

The relationship between the extrinsic observable signal (the raw signal)
and an intrinsic covarying spike train (the spike train) is assumed to be mediated
by a latent signal (the firing rate, or transformed signal).

### Text diagram of the model
```
     conv. w/ kernel       Poisson process
           |                     |
raw signal -> transformed signal -> spike train
```

### Transforming the raw signal
The relationship between the raw signal and the transformed signal
is defined by a convolution with an
[exponentially-modified Gaussian kernel](https://en.wikipedia.org/wiki/Exponentially_modified_Gaussian_distribution).

```
transformed_signal = conv(kernel, raw_signal)
```

The kernel used here has four parameters.
All parameters are positive, real constants.

* **alpha**: scaling parameter
* **mu**: mean parameter
* **sigma**: standard deviation parameter
* **tau**: time constant parameter

The two most important parameters are mu and tau.
Mu determines the degree of lag between the raw signal and the transformed signal.
Tau determines the (inverse) rate of decay of the transformed signal.

### Generating the spike train

The spike train is assumed to be generated by a
[non-homogeneous Poisson process](https://en.wikipedia.org/wiki/Poisson_point_process#Inhomogeneous_Poisson_point_process).

```
spike_train = poisson(transformed_signal)
```

### An illustrated example

Here is some artificial sample data showing animal running speed
(an extrinsic, observable signal)
and a sample kernel.

![test_kernel](https://user-images.githubusercontent.com/30243182/80112730-6ca6c200-854f-11ea-81a3-ce6a14e7e4dc.png)

Here we show the raw signal, the transformed signal
produced by convolving the raw signal with the kernel,
and a spike train generated by treating the transformed signal
as the generating function of a non-homogeneous Poisson process.

![test_kernel](https://user-images.githubusercontent.com/30243182/80112765-77615700-854f-11ea-9023-f8916a25f112.png)

<!-- ## Step 1: Collect the raw data

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
latent time-varying signal can be written as a convolution.
We convolve the biological signal with an exponentially-modified Gaussian kernel.
Then, we treat this signal as the rate of a non-homogeneous Poisson process
and generate a spike train.

We maximize the log-likelihood of the Poisson process
in order to indirectly optimize the kernel parameters. -->
