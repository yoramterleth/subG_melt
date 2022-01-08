%% combine variables in struct 
function [OUT] = TIME_assemble(u,Tb,M)


% velocity: convert to meters per day 
OUT.velocity = u.Ubase .* 86400 ; 

% shear stress 
OUT.TB = Tb.Tb ; 

% melt: convert to mm
OUT.melt = M.M .* 1000; 