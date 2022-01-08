%% model to estimate rates of basal melting from surface velocities 
%% yoram terleth %% Nov 2021


%% clean up 
close all
clc
clearvars

%% INITIALISATION 
[par,time,OUT,OUTFILE] = INIT_parameters();
[grid] = INIT_DEM(par);


%% Dynamic component 
for t=1:time.tn

[time] = TIME_print_time(t,time);
    
[u] = TIME_velocity(par,grid,t) ;

[Tb] = TIME_shear_stress(par,u,t) ; 

[M] = TIME_basal_melt(Tb,par,u,grid,t) ; 

[OUT] = TIME_assemble(u,Tb,M) ; 

[par,OUTFILE] = TIME_write_to_file(OUTFILE,par,OUT,grid,t,time) ; 

end 



