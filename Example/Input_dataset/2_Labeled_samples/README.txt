Each folder contains the dataset used to train the classifir for each year. Note that it is possible to use the same dataset to train different years.

Each dataset contains:
1) the base images: multilayer rasters that hold the observation value for each class;
2) the labeled samples: a single layer raster that holds the index that identifies the class. The rasters are of the same extent, projection, and size of the base images. Here, a value equal to 0 (zero) represents that the pixel was not considered as a sample. Every other value denotes a class.

Please notice the differences in dataset of each year regarding type of image, used legend for labeled smaples collection, and number and type od sample collection.


# 2008

Corresponds to an subset of an image from the  satellite/sensor Advanced Land Observing System (ALOS)/Phase Array L-Band Synthetic Aperture Radar (PALSAR). This image was acquired in Fine Beam Dual mode, at 1.1 processing level on 2008-06-15, and is made avalilable after preprocessing, in aplitude format, polarizations HH (channel 1) and VH (channel 2), speckle filtered and with 15 m of pixel size (details on Reis et al. (2020)).

Each index in the labeled raster represents a class:

1. BS
2. CA+IA
3. CP+SP
4. SV1+SV2+SV3
5. MA+MF


# 2010

Corresponds to subsets of mosaics from the  satellite/sensor Landsat 5/ Thematic Mapper (TM). These images were acquired between June and August of 1993, 2004, and 2008 and made available in surface reflectance, bands 4,5, and 7 (channels 1,2, and 3) and geometric and radiometric corrected (please see processing details in Chapter 6 of Reis (2022)). In this folder, these images are presented in the original pixel size of 30 m.

Each index in the labeled raster represents a class:

1. BS
2. CA
3. IA
4. CP
5. SP
6. SV1+SV2+SV3 
7. MA
8. MF
9. MF2

Note that not all classes were contmeplated for all dates or at all. It is not a problem. When training with two or more sets of data, the index must represent the same class within the datasets using for training of a given image.

# 2013

Corresponds to an subset of an image from the  satellite/sensor Earth Observer 1 (EO-1)/Advanced Land Imager (ALI). This image was acquired on 2013-10-05, and is made avalilable after preprocessing, bands 4', 5', and 7 (channels 1,2, and 3), with 15 m of pixel size (details on Reis et al. (2020)).

Each index in the labeled raster represents a class:

1. MA
2. SV1
3. SV2
4. SV3
5. IA
6. CP+SP 
7. MF
8. BS



M. S. Reis, L. V. Dutra, M. I. S. Escada and S. J. S. Sant’anna. "Avoiding Invalid Transitions in Land Cover Trajectory Classification With a Compound Maximum a Posteriori Approach," in IEEE Access, vol. 8, pp. 98787-98799, 2020, doi: 10.1109/ACCESS.2020.2997019.

M. S. Reis. "Detection and analysis of forest regeneration trajectories in the lower Tapajós region". 2022. 220 p. IBI: <8JMKD3MGP3W34T/47E2TRB>. (sid.inpe.br/mtc-m21d/2022/08.11.11.21-TDI). Thesis (PhD in Earth System Science) - National Institute for Space Research (INPE), São José dos Campos, 2022. Available at: <http://urlib.net/ibi/8JMKD3MGP3W34T/47E2TRB>.
