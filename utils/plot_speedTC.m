function plot_speedTC(root)
% plots speed tuning curve from root object
% set cel and epoch before calling this function

speed = CMBHOME.Utils.ContinuizeEpochs(root.svel);
edges = [0:floor(prctile(speed,95))];

epoch = root.epoch;
root.epoch = [-inf inf];

indsEpoch = get_inds_from_epoch(root,epoch);

spktimes = get_spktimes_of_cel(root,root.cel);
[spkRate,~] = get_InstFR(spktimes,root.ts,root.fs_video,'filter_length',125,'filter_type','Gauss');

 [mean_y_per_xBin,xbar,std_y_per_xBin] = get_histTwoVectorInput(root.svel(indsEpoch),spkRate(indsEpoch),edges);
 
 figure
 scatter(xbar,mean_y_per_xBin,'filled','k')
 r = refline;
 r.Color = 'r';

