# the Compound Maximum a Posteriori (CMAP) algorithm


CMAP incorporates the knowledge of land cover dynamics and the information of multi-temporal data sets to produce only valid land cover trajectories using a global generative classification approach and simple inputs. Consider that the user wants to classify a image time-series into land cover classes. In this time-series, each image corresponds to one time of interest to be classified. To use CMAP, the user needs:

1) The images that carry the observation indicative of each classe at each time (images that are going to be classified);
2) Labeled samples of land cover classes of interest;
3) The a priori probability of each land cover trajectory.

The CMAP classification was organized in three steps, to allow for the easy modification of the process:

1) Calculation of the probability of classes given the observation;
2) Calculation of the a priori probability of trajectories;
3) Computation of CMAP and classification of results.

These codes are under revision and being made public accordingly. Preliminary versions of codes and input datasets may be made available conditioned to direct and reasonable requests. Please either create an Issue (https://github.com/marianesreis/CMAP/issues) or contact me on mariane.reis@inpe.br for more information.

When using the algorithm, please cite the original paper:
M. S. Reis, L. V. Dutra, M. I. S. Escada and S. J. S. Sant’anna, "Avoiding Invalid Transitions in Land Cover Trajectory Classification With a Compound Maximum a Posteriori Approach," in IEEE Access, vol. 8, pp. 98787-98799, 2020, doi: 10.1109/ACCESS.2020.2997019.


Please check the following steps for a demonstration input dataset and example of R script to use CMAP.

---

This example aims to classify a short remote sensing time-series into a land cover classification time series. We will classify three images from different sensors (ALOS/PALSAR, Landsat 5/TM, and EO-1/ALI) and dates (2008, 2010, and 2013). We will also consider different legends for each date. Note that the training and classification process are done in independent (but cross-calibrated) datasets, which allows for the use of samples collected in images from other sites/dates than the one being classified.

For this example, we will consider that you have installed a suitable version of R and the package "raster". This example also considers the use of the "example_dataset" and the R codes "MainFunctions.R" and "AuxiliaryFunctions.R". We further consider that the working directory is set to a folder containing these data.


First, load the necessary package and the R codes:
```{r}
library(raster)

source("MainFunctions.R")

source("AuxiliaryFunctions.R")

```

