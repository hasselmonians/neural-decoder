% show summary statistics of the data table
% containing the four parameters of the EMG kernel
% after running the NeuralDecoder protocol on Holger's dataset

being_published = true;
pdflib.header;
tic;

% load the data
package_dir = pathlib.strip(mfilename('fullpath'), 2);
load(fullfile(package_dir, 'data', 'Holger-SM-NeuralDecoder.mat'));

%% Introduction
% Take Holger's dataset of rats freely exploring an empty, square arena,
% and compute the relationship between the firing rate of
% putatively speed-modulated cells,
% and the running speed of the animal.
% We assume that this relationship is given by convolution
% of the running speed with a four-parameter exponentially-modified
% gaussian kernel.
%
% The four parameters are |alpha|, |mu|, |sigma|, and |tau|.
% |alpha| is a scaling parameter which accounts for differences
% in magnitude between the running speed and the firing rate.
% It is bounded in |[0, 2]|.
% |mu| is the lag parameter and analogous to the parameter of the same name
% in the gaussian probability density function.
% It is bounded in |[0, 30]|.
% |sigma| is the spread parameter,
% the correlate of the gaussian standard deviation parameter,
% and it is bounded in |[0, 15]|.
% |tau| is the decay parameter, is analogous to the time constant
% of an exponential probability density function,
% and is bounded in |[0, 15]|.
%
% Holger's dataset was separated into putatively speed-modulated,
% and putatively non-speed-modulated cells
% using a GLM (Dannenberg et al. 2019, Prerau & Eden 2011, Hardcastle et al. 2017).

%% Summary statistics

summary(data_table)

%% Scatter plots with marginal histograms

parameter_names = {'alpha', 'mu', 'sigma', 'tau'};
parameter_combinations = nchoosek(parameter_names, 2);

for ii = colon(size(parameter_combinations, 1), -1, 1)
	figure('OuterPosition',[0 0 1600 1600],'PaperUnits','points','PaperSize',[1600 1600]);

	s(ii) = scatterhistogram(data_table, parameter_combinations{ii, 1}, parameter_combinations{ii, 2}, ...
	  'HistogramDisplayStyle', 'smooth', ...
	  'LineStyle', '-');

	xlabel(['\' parameter_combinations{ii, 1}])
	ylabel(['\' parameter_combinations{ii, 2}])

	if being_published
	  pdflib.snap()
	  delete(gcf)
	end
end

%% Samples

for ii = 1:5
	plotTimeSeries(data_table, ii, ...
		'PreProcessFcn', @(x) strrep(x, 'projectnb', 'mnt'), ...
		'Verbosity', false);
	if being_published
		pdflib.snap()
		delete(gcf)
	end
end

%% Version Info
% The file that generated this document is called:
disp(mfilename)

%%
% and its md5 hash is:
disp(hashlib.md5hash(strcat(mfilename, '.m'), 'File'))

%%
% This file should be in this commit:
[status,m]=unix('git rev-parse HEAD');
if ~status
	disp(m)
end

t = toc;

%%
% This file has the following external dependencies:
pdflib.showDependencyHash(mfilename);
