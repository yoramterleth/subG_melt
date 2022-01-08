function [Tb] = TIME_shear_stress(par,u,t) 


%% calculate basal shear stress 
if strcmp(par.slip_law,'PISM')
% calculate yield stress for pism
Tc = par.c0 + tan(deg2rad(par.mat_param)).*(par.pi - par.pw) ; 

Tb.Tb = Tc .* (u.Ubase ./ ((abs(u.Ubase).^(1-par.q)).*(par.u0.^par.q))) ;
Tb.Tb_2D = Tc .* (u.Ubase_2D ./ ((abs(u.Ubase_2D).^(1-par.q)).*(par.u0.^par.q))) ;

elseif strcmp(par.slip_law,'ZOET_IVERSON')
Tb.Tb = (par.pi - par.pw) .* tan(deg2rad(par.mat_param)) .* (u.Ubase ./ (u.Ubase + par.u0)).^(1/par.p); 
Tb.Tb_2D = (par.pi - par.pw) .* tan(deg2rad(par.mat_param)) .* (u.Ubase_2D ./ (u.Ubase_2D + par.u0)).^(1/par.p);

elseif strcmp(par.slip_law, 'WEERTMAN') 
Tb.Tb = ((u.Ubase .* (par.pi - par.pw))./par.Cs).^(1./par.p) ; 
Tb.Tb_2D = ((u.Ubase_2D .* (par.pi - par.pw))./par.Cs).^(1./par.p) ; 

elseif strcmp(par.slip_law, 'BEAUD')
alpha = ((par.qb - 1).^(par.qb-1))/(par.qb.^par.qb) ; 
Tb.Tb = ((par.pi - par.pw).* tan(deg2rad(par.mat_param))).* ...
    (((u.Ubase ./ par.u0)./(1+(alpha.*((u.Ubase./par.u0).^par.qb)))).^(1/par.p)); 
Tb.Tb_2D = ((par.pi - par.pw).* tan(deg2rad(par.mat_param))).* ...
    (((u.Ubase_2D ./ par.u0)./(1+(alpha.*((u.Ubase_2D./par.u0).^par.qb)))).^(1/par.p)); 

else 
    disp('Slip law not specified correctly.')
end 

end 
