%% test script

[firing_rate_estimate, neurodec, options] = generateSampleData();

%% Plot the fake data and the kernel

figure;
subplot(1, 2, 1);
plot(neurodec.timestamps, options.Signal, 'k');
box off
xlabel('time (s)')
ylabel('animal running speed (cm/s)')
title('sample data')
subplot(1, 2, 2);
plot(neurodec.getKernelSupport(), neurodec.kernel, 'k')
box off
xlabel('time (s)')
ylabel('kernel')
my_title = { ...
        'exGaussian kernel', ...
        ['(\alpha = ' strlib.oval(options.Params(1), 2) ...
        ', \mu = ' strlib.oval(options.Params(2), 2) ...
        ', \sigma = ' strlib.oval(options.Params(3), 2) ...
        ', \tau = ' strlib.oval(options.Params(4), 2) ')'] ...
        };
title(my_title)
figlib.pretty('PlotBuffer', 0.1)

%% Plot the convolution, the spike train, and the raw data

figure;

% plot the raw signal
ax(1) = subplot(3, 1, 1);
plot(neurodec.timestamps, options.Signal, 'k')
ylabel('animal running speed (cm/s)')
box off

% plot the transformed signal
ax(2) = subplot(3, 1, 2);
plot(neurodec.timestamps, firing_rate_estimate, 'k')
box off
ylabel('firing rate (Hz)')

% plot the spike train
ax(3) = subplot(3, 1, 3);
stem(neurodec.timestamps, neurodec.spikeTrain, 'Marker', 'None', 'Color', [0 0 0])
ylabel('# spikes')
box off

xlabel('time (s)')
linkaxes(ax, 'x');

% label the plots
title(ax(1), 'raw signal')
title(ax(2), 'transformed signal')
title(ax(3), 'sample spike train')

figlib.pretty('PlotBuffer', 0.2, 'PlotLineWidth', 1);

%% Compute the log-likelihood

loglikelihood = neurodec.loglikelihood(firing_rate_estimate)
