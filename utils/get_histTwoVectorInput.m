function [mean_y_per_xBin,xbar,std_y_per_xBin] = get_histTwoVectorInput(x,y,edges,varargin)
% function [mean_y_per_xBin,xbar,std_y_per_xBin] = get_histTwoVectorInput(x,y,edges,varargin)
%gets histogram for data y(x) with y1 = y(x1), y2 = y(x2), ... , yend =
% y(xend) for bins of vector x determined by vector edges.
% varargin: 'fig' = 1 plots figure
% 10-26-18: Holger added std_spkRate_per_speedBin as output

% inputParser
p = inputParser;
addParameter(p,'fig',0)
parse(p,varargin{:})
fig = p.Results.fig;

bin_width = edges(2)-edges(1); % bin_width

if length(x) ~= length(y)
    disp('Vectors x and y must have the same length!')
    return
end

% group values from vector x into bins
[xbins] = discretize(x,edges);
x_min = min(xbins);
x_max = max(xbins);
if isnan(x_min)
    mean_y_per_xBin = nan;
    xbar = nan;
    return
end
    
% if xbins or y are not column vectors, transpose vectors to make them
% column vectors
if size(xbins,1) < size(xbins,2)
    xbins = xbins';
end
if size(y,1) < size(y,2)
    y = y';
end

% remove nan values
y(isnan(xbins)) = [];
xbins(isnan(xbins)) = [];

% get histogram
histcounts_cel = cell(x_max-x_min+1,1); % preallocate variable
for i = x_min:x_max
    histcounts_cel{i} = y(xbins==i); % stores spiking rate values per binned speed values
end
% calculate mean value and std per speed bin
mean_y_per_xBin = nan(length(histcounts_cel),1); % preallocate variable
std_y_per_xBin = nan(length(histcounts_cel),1);
sem_y_per_xBin = nan(length(histcounts_cel),1);
for i = 1:length(histcounts_cel)
    mean_y_per_xBin(i) = nanmean(histcounts_cel{i});
    std_y_per_xBin(i) = nanstd(histcounts_cel{i});
    sem_y_per_xBin(i) = std_y_per_xBin(i)./sqrt(length(histcounts_cel{i,1}));
end
% delete empty speed bins smaller than xmin
mean_y_per_xBin(1:x_min-1) = [];
std_y_per_xBin(1:x_min-1) = [];
sem_y_per_xBin(1:x_min-1) = [];
% create vector with speed bins matching to mean_spkRate_per_speedBin
% vector
xbar = linspace(edges(x_min),edges(x_max),length(mean_y_per_xBin));
xbar = xbar + bin_width/2; % adjust xbar values to display the middle of the speed bin
% remove non-existing speed bins and corresponding values in
% mean_spkRate_per_speedBin. non-existing speed bins are speed bins where
% the corresponding values in mean_spkRate_per_speedBin are nan values.
xbar(isnan(mean_y_per_xBin)) = [];
sem_y_per_xBin(isnan(mean_y_per_xBin)) = [];
std_y_per_xBin(isnan(mean_y_per_xBin)) = [];
mean_y_per_xBin(isnan(mean_y_per_xBin)) = [];

% plot figure with std errorbars
if fig && ~isempty(xbins)
    figure
    errorbar(xbar,mean_y_per_xBin,std_y_per_xBin)
end

% plot figure with sem errorbars
if fig && ~isempty(xbins)
    figure
    errorbar(xbar,mean_y_per_xBin,sem_y_per_xBin)
end
