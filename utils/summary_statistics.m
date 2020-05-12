%% Produce summary statistics for the four parameters

function s = summary_statistics(data_table)

  summary(data_table)

  %% Scatter plots with marginal histograms

  parameter_names = {'alpha', 'mu', 'sigma', 'tau'};
  parameter_combinations = nchoosek(parameter_names, 2);

  for ii = colon(size(parameter_combinations, 1), -1, 1)
    figure;
    s(ii) = scatterhistogram(data_table, parameter_combinations{ii, 1}, parameter_combinations{ii, 2}, ...
      'HistogramDisplayStyle', 'smooth', 'LineStyle', '-');
    xlabel(['\' parameter_combinations{ii, 1}])
    ylabel(['\' parameter_combinations{ii, 2}])
  end

end % function
