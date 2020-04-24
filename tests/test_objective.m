function [my_data] = test_objective()

    %% Description:
    %   Test the computation of the objective function;
    %   specifically, how to turn log-likelihood into an objective
    %   that approaches 0 from the positive direction.

    % define some monotonically increasing likelihoods
    likelihoods = logspace(-10, 10);
    loglikelihoods = log(likelihoods);

    % compute some objective values, given the likelihoods
    objectives = NaN(size(loglikelihoods));

    for ii = 1:length(objectives)
        objectives(ii) = cost(loglikelihoods(ii));
    end

    % store data in the table
    my_data = table(likelihoods', loglikelihoods', objectives', ...
        'VariableNames', {'likelihood', 'loglikelihood', 'objective'});

    % plot the results
    figure; plot(my_data.loglikelihood, my_data.objective);
    figlib.pretty('PlotBuffer', 0.2)

    function y = cost(x)
      if x <= 0
        y = abs(x)+3;
      else
        y = 1 / x;
      end
  end % function

end % function
