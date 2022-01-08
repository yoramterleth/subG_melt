function [M] = TIME_basal_melt(Tb,par,u,grid,t) 


%% calculate geothermal heat flux (paterson 1993 - Alexander 2011)
M.M_2D = (par.G + (Tb.Tb_2D .* u.Ubase_2D) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 
M.M = (par.G + (Tb.Tb .* u.Ubase) - (par.Ki .* par.I_t_grad)) ./ (par.LIce .* par.densIce) ; 


end 