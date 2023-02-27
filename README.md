# the Compound Maximum a Posteriori (CMAP) algorithm
R codes to classify a remote sensing time-series into land cover trajectories using the Compound Maximum a Posteriori (CMAP) algorithm.

These codes are under revision and being made public accordingly. Preliminary versions of codes and input datasets may be made available conditioned to direct and reasonable requests. Please either create an Issue (https://github.com/marianesreis/CMAP/issues) or contact me on mariane.reis@inpe.br for more information.

When using the algorithm, please cite the original paper:
M. S. Reis, L. V. Dutra, M. I. S. Escada and S. J. S. Sant’anna, "Avoiding Invalid Transitions in Land Cover Trajectory Classification With a Compound Maximum a Posteriori Approach," in IEEE Access, vol. 8, pp. 98787-98799, 2020, doi: 10.1109/ACCESS.2020.2997019.


CMAP incorporates the knowledge of land cover dynamics and the information of multi-temporal data sets to produce only valid land cover trajectories using a global generative classification approach and simple inputs. Consider that the user wants to classify a image time-series into land cover classes. In this time-series, each image corresponds to one time of interest to be classified. To use CMAP, the user needs:

1) The images to be classified in each date (observation of each classe at each time);
2) The labeled samples of land cover to be classified in each time;
3) The a priori probability of each land cover trajectory.

The CMAP classification was organized in three steps, to allow for the easy modification of the process:

1) Calculation of the probability of classes given the observation;
2) Calculation of the a priori probability of trajectories;
3) Computation of CMAP and classification of results.

Please check the folder "Example" for a demonstration input dataset and example of R script to use CMAP.

