# subG_melt

Simple spatially distributed model computing basal melt from an input of surface velocities. 

The surface velocity is scaled to represent basal slip, and used to calculate shear stress following four different formulations. Basal melt is calculated from shear stress following the standard Cuffey \& Paterson description. 

* INIT_parameters should be used for user input and run choices. 
* The sat_vel_all.mat file contains surface velocity records for Sit Kusa. Another option is to use synthetic velocities by turning "real_velocities" off in the parameter file. 
* The sat_vel_all.mat file contains elevation data for the northern tributary of Sit Kusa. The data is cropped from ArcticDEM. 
* subGmelt_main runs the model. 
* FIGURE_distributed returns 2D plots of the model output. Users can choose to show average sliding velocity, average basal shear stress, or basal melt summed over the run period. 
* FIGURE_time returns a time series of the model output. Users can choose to show average sliding velocity, average basal shear stress, or basal melt. 
* Analytical figures creates a figure showing the evolution of basal shear stress and basal melting for a range of sliding velocities. 
