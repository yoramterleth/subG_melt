%% load DEM information as support for the model
% this function is partly based on work by W. Van Pelt (https://github.com/wardvp/EBFM-glacier). 
function [grid] = INIT_DEM(par)

%% load in DEM 
% if the DEM covers an area wider than the glacier also provide a mask
% logical matrix. 
input = load(par.DEMname) ; 


grid.x_2D = input.TG.x;
grid.y_2D = input.TG.y;
grid.z_2D = input.TG.z;
grid.utmzone = input.UTM_zone ; 

grid.Lx = size(grid.x_2D,1);
grid.Ly = size(grid.y_2D,2);

grid.mask_2D = input.mask;

[~,FY] = gradient(grid.y_2D);
if FY(1)<0
    grid.x_2D = flipud(grid.x_2D);
    grid.y_2D = flipud(grid.y_2D);    
    grid.z_2D = flipud(grid.z_2D);
    grid.mask_2D = flipud(grid.mask_2D);
end
[FX,~] = gradient(grid.x_2D);
if FX(1)<0
    grid.x_2D = fliplr(grid.x_2D);
    grid.y_2D = fliplr(grid.y_2D);    
    grid.z_2D = fliplr(grid.z_2D);
    grid.mask_2D = fliplr(grid.mask_2D);
end

grid.gpsum = sum(grid.mask_2D(:)==1);
grid.mask = grid.mask_2D(grid.mask_2D(:)==1);

[grid.lat_2D,grid.lon_2D] = utm2ll(grid.x_2D,grid.y_2D,grid.utmzone);

grid.x = grid.x_2D(grid.mask_2D(:)==1); 
grid.y = grid.y_2D(grid.mask_2D(:)==1);
grid.z = grid.z_2D(grid.mask_2D(:)==1);
grid.ind = find(grid.mask_2D==1);
[grid.xind, grid.yind] = find(grid.mask_2D==1);
end 


