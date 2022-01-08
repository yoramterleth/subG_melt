%% Analytical figures %%
%% %%%%%%%%%%%%%%%%%% %%

clearvars
close all 
clc

%% INITIALISATION 

[par,time] = INIT_parameters();

u.Ubase = [0.01:0.1:1,1:0.1:40]./86400; 


%% SHEAR STRESS FORMULATIONS 

% PISM, as in van pelt & Oerlemans 2011
Tc = par.c0 + tan(deg2rad(par.mat_param)).*(par.pi - par.pw) ; 
Tb.PISM = Tc .* (u.Ubase ./ ((abs(u.Ubase).^(1-par.q)).*(par.u0.^par.q))) ;

% Zoet & Iverson 2020 for soft beds
Tb.ZI = (par.pi - par.pw) .* tan(deg2rad(par.mat_param)) .* (u.Ubase ./ (u.Ubase + par.u0)).^(1/par.p); 

% Weertman / Bindschadler, etc. 
Tb.W = ((u.Ubase .* (par.pi - par.pw))./par.Cs).^(1./par.p) ; 

% Beaud 2021, adapted for soft beds
alpha = ((par.qb - 1).^(par.qb-1))/(par.qb.^par.qb) ; 
Tb.B = ((par.pi - par.pw).* tan(deg2rad(par.mat_param))).* ...
    (((u.Ubase ./ par.u0)./(1+(alpha.*((u.Ubase./par.u0).^par.qb)))).^(1/par.p)); 

%% BASAL MELT FORMULATIONS

% PISM 
bm.PISM = (par.G + (Tb.PISM .* u.Ubase) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 

% Zoet & Iverson 
bm.ZI = (par.G + (Tb.ZI .* u.Ubase) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 

% Weertman 
bm.W = (par.G + (Tb.W .* u.Ubase) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 

% Beaud 
bm.B = (par.G + (Tb.B .* u.Ubase) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 

%% VISUALIZATION 

u.Ubasemd = u.Ubase .* 86400 ; 
 
figure

subplot(2,1,1)
plot(u.Ubasemd, Tb.W,'linewidth',1.8), hold on 
plot(u.Ubasemd, Tb.PISM,'linewidth',1.8)
plot(u.Ubasemd, Tb.ZI,'linewidth',1.8)
plot(u.Ubasemd, Tb.B,'linewidth',1.8)

xlabel('Sliding velocity [m day^{-1}]')
ylabel('Basal shear stress [kPa]')

legend('Weertman','PISM','Zoet & Iverson','Beaud et al.','Location','NorthWest')

grid on

subplot(2,1,2)
plot(u.Ubasemd, bm.W .* 86400000 ,'linewidth',1.8), hold on 
plot(u.Ubasemd, bm.PISM .* 86400000 ,'linewidth',1.8)
plot(u.Ubasemd, bm.ZI .* 86400000 ,'linewidth',1.8)
plot(u.Ubasemd, bm.B .* 86400000 ,'linewidth',1.8)

xlabel('Sliding velocity [m day^{-1}]')
ylabel('Basal melting [mm day^{-1}]')

legend('Weertman','PISM','Zoet & Iverson','Beaud et al.','Location','NorthWest')

grid on

