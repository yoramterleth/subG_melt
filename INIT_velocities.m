function [measured_vels] = INIT_velocities(time,par) 

if par.real_velocities
    %% load sattelite velocity data
    load(par.velocity_filename)
    SV.t = sat_vel.t_mid ;
    SV.v = sat_vel.s24 ; 

    % sort it into ascending order 
    sorted = sortrows(table(SV.t,SV.v)) ; 
    [~,ia] = unique(sorted.Var1) ; 
    sorted = sorted(ia, :) ; 
    sorted = sorted(~isnan(sorted.Var2),:) ; 

    %% interpolate onto the set time-steps 
    t_vector = time.ts:days(time.dt):time.te ; 
    measured_vels = interp1(sorted.Var1, sorted.Var2,t_vector','linear','extrap') ; 
    
    % convert the velocities to m/second
    measured_vels = measured_vels ./ 3.154e+7 ; 
else 
    measured_vels = [] ; 

end 

  figure 
  plot(t_vector, measured_vels*86400 ) 
  ylabel('Velocity forcing (m day^{-1})')
end 








