%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% FIGURES TIME-SERIES:
%%% Creates time-series of a specified variable for a specified point 
%%% location and time-period
%%% This script is based on figures_distributed by W. Van Pelt. 
%%% adapted to work here jan 2022.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% USER SPECIFICATIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

coords =  [566414, 6669400] ;               % location (UTM)
timeseries_start = '1-Sep-2016 00:00';      % start date
timeseries_end = '15-Aug-2022 00:00';       % start time
var = 'melt';                               % plot variable (choose from list 
outdir = [pwd '\output'] ;                  % 	in io.varsout)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load([outdir '\runinfo.mat']);

ind = find(strcmp(var,{IOout.varsout.varname}));

L = length(grid.mask);
time_start = time.ts;
time_end = time.te;
period = IOout.freqout*time.dt;
tvec = datenum(time_start):period:datenum(time_end);
T = (datenum(time_end) - datenum(time_start))/period;

diff_y = grid.y(:)-coords(2);
diff_x = grid.x(:)-coords(1);
diff = sqrt(diff_y.^2 + diff_x.^2);
gp = find(diff == min(diff));

varabr = IOout.varsout(ind).varname;
varname = IOout.varsout(ind).description;
units = IOout.varsout(ind).units;
type = IOout.varsout(ind).type;

taxis = datetime(datevec(datenum(timeseries_start):IOout.freqout*...
    time.dt:datenum(timeseries_end)+0.5*IOout.freqout*time.dt));
tind = [];
taxis_plot_datenum = [];
for tt=1:length(taxis)
    if min(abs(datenum(IOout.output_times)-datenum(taxis(tt))))<...
            IOout.freqout*time.dt
        [~,tind(end+1)] = min(abs(datenum(IOout.output_times)-...
            datenum(taxis(tt))));
        taxis_plot_datenum(end+1) = datenum(IOout.output_times(tind(end)));
    end
end
taxis_plot = datetime(datevec(taxis_plot_datenum));

Atime = [];

fid = fopen([outdir '/OUT_' varabr '.bin'],'rb');
count = 0;
for t=1:length(tind)
    fseek(fid,(tind(t)-1)*4*L+(gp-1)*4,'bof');
    Atemp = fread(fid,1,'real*4','l');
    Atime(end+1) = Atemp;
end
fclose(fid);



%% FIGURE
f = figure;
plot(taxis_plot,Atime,'linewidth',1);
xlabel('Date');
ylabel([varname ' (' units ')']);
title(varname);
xlim([datetime(timeseries_start) datetime(timeseries_end)]);
grid on 


%% plot the location 
figure 
contour(grid.x_2D, grid.y_2D,grid.z_2D.*grid.mask_2D, [0:20:3000],'k'), hold on 
scatter(coords(1),coords(2),'r','filled')

legend('','sample location') %'used in loadmelt')
