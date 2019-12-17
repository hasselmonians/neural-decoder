# neural-decoder
Produces a model of the relationship between an extrinsic observable signal and an intrinsic covarying spike train

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
