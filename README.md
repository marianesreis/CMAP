# the Compound Maximum a Posteriori (CMAP) algorithm


CMAP incorporates the knowledge of land cover dynamics and the information of multi-temporal data sets to produce only valid land cover trajectories using a global generative classification approach and simple inputs. Consider that the user wants to classify an image time series into land cover classes. Each image corresponds to one time of interest in this time series to be classified. To use CMAP, the user needs:

1) The images that carry the observation indicative of each class at each time (images that are going to be classified);
2) Labeled samples of land cover classes of interest;
3) The a priori probability of each land cover trajectory.

The CMAP classification was organized in three steps, to allow for the easy modification of the process:

1) Calculation of the probability of classes given the observation;
2) Calculation of the a priori probability of trajectories;
3) Computation of CMAP and classification of results.

These codes are under revision and being made public accordingly. Please check the HTML file "HowtoCMAP.html" in the root folder (alternatively: https://marianesreis.github.io/CMAP/) for a demonstration of the input dataset and an example of an R script to use CMAP. Please create an Issue (https://github.com/marianesreis/CMAP/issues) or contact me at mariane.reis@inpe.br for more information and/or suggestions.

When using the algorithm, please cite the original paper:
M. S. Reis, L. V. Dutra, M. I. S. Escada, and S. J. S. Sant’anna, "Avoiding Invalid Transitions in Land Cover Trajectory Classification With a Compound Maximum a Posteriori Approach," in IEEE Access, vol. 8, pp. 98787-98799, 2020, doi: 10.1109/ACCESS.2020.2997019.

