function [U] = TIME_velocity(par,grid,t)

if par.real_velocities
    %% here include rescaling to out grid of the surface velocities
    
else 
    %% here we include a synthetic velocity field for testing 
    % during a surge, the main trunck is fast and all else is slow
    % we use an elevation to separate the two 
    
    Usurf = zeros(grid.Lx,grid.Ly); 
    Usurf(grid.z_2D < par.z_max_trunck)= par.surge_vel ;
    Usurf(grid.z_2D >= par.z_max_trunck)= par.quiesc_vel ;
    U.Usurf_2D = Usurf .* grid.mask_2D;
    U.Usurf = U.Usurf_2D(grid.mask_2D(:)==1); 
    
    U.Ubase_2D = U.Usurf_2D .* par.u_slip_prop ; 
    U.Ubase = U.Ubase_2D(grid.mask_2D(:)==1);
    
end 