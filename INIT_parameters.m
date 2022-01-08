%% INIT_parameters 
function [par,time,OUT,OUTFILE] = INIT_parameters()

%% model runtime and info 

time.ts = datetime('2020-09-01','InputFormat','yyyy-MM-dd');
time.te = datetime('2021-09-01','InputFormat','yyyy-MM-dd');

time.dt = 1.125;                                                            % Timestep (days)
time.tn = round((datenum(time.te)- ...                                      % Nr. of time-steps
    datenum(time.ts))/time.dt)+1;
time.dT_UTC = 1; 

par.slip_law = 'WEERTMAN';                                                      % can be 'PISM' or 'ZOET_IVERSON'or 'WEERTMAN' or 'BEAUD'

par.outdir = [pwd '\output\'] ; 
%% DEM (name of file, should be in main folder)
par.DEMname = 'TG.mat' ; 

%% free parameters

%% ice properties 
par.I_t_grad = 0 ;                                                          % thermal gradient in the ice layer
par.Ki =   2.10 ;                                                           % [Wm-1K-1] thermal conductivity of ice 

par.densIce = 917 ;                                                         % [kg m-3] ice density
par.LIce = 333.5 * 1000;                                                    % [J kg-1] latent heat of fusion of ice

%% ice velocity 
par.real_velocities = 0 ;                                                   % real velocities available?
par.z_max_trunck = 900 ;                                                    % max eleavtion with surging ice: meant to separate out the trunk [m asl]

par.surge_vel = 30/86400 ;                                                  % surge surf velocities [m.s-1]
par.quiesc_vel = 3/86400 ;                                                  % quiescence velocities [m.s-1]

par.u_slip_prop = .95 ;                                                     % proportion of surface velocity explained by basal slip 

%% till/basal properties 
par.c0 = 0 ;                                                                % till cohesion:  0 in van pelt 2012
par.mat_param = 30 ;                                                        % [degrees]: ranges from 7.5 to 30 
par.pi = 1000 ;                                                             % overburden pressure ( p*g*H)
par.pw = 900 ;                                                              % water pressure (alpha p g H (W/W0) - see van pelt & oerlemans 2012

par.q = 0.3 ;                                                               % pseudoplasticity exponent (Clarcke 2005)
                                                                            % ranges from 0 (perfectly plastic till to 1(linearly viscous till)
par.u0 = 1000  /(365*86400) ;                                               % constant theshold velocity used in van pelt & oerlemans 2012

par.p = 3 ;                                                                 % power law exponent for Zoet & Iverson 2020: Beaud et al 2021 use p =3. 

par.Cs = (2.5e-9); %.* (365*86400) ;                                        % sliding coefficient [m.s-1.Pa-p]

par.qb = 3 ;                                                                % exponent for Beaud formualtions: differentiates from Zoet & Iverson & 
                                                                            % brings rate weakenign behavior

par.G = 0.05 ;                                                              % geothermal heat flux [W m-2]

%% files and storage initiations 
OUT = struct;                                                               % structure containing model output variables
OUTFILE = struct;                                                           % output to be saved to files

end 
