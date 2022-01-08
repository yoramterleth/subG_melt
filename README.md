# subG_melt

Simple spatially distributed model computing basal melt from an input of surface velocities. 

The surface velocity is scaled to represent basal slip, and used to calculate shear stress following four different formulations. Basal melt is calculated from shear stress following the standard Cuffey \& Paterson description. 

* INIT_paremeters should be used for user input and run choices. 
* subGmelt_main runs the model. 
* FIGURE_distributed returns 2D plots of the model output. Users can choose to show average sliding velocity, average basal shear stress, or basal melt summed over the run period. 
