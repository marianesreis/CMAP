Each folder contains the dataset used to train the classifier for each year. Note that it is possible to use the same dataset to train different years.

Each dataset contains:
1) the base images: multilayer rasters that hold the observation value for each class;
2) the labeled samples: a single layer raster that holds the index that identifies the class. The rasters are of the same extent, projection, and size of the base images. Here, a value equal to 0 (zero) represents that the pixel was not considered as a sample. Every other value denotes a class.

Please notice the differences in dataset of each year regarding type of image, used legend for labeled smaples collection, and number and type od sample collection. This dataset corresponds to the one used in Reis et al. (2020), which the reader is invited to consult for further details.


# 2008

Corresponds to an subset of an image from the  satellite/sensor Advanced Land Observing System (ALOS)/Phase Array L-Band Synthetic Aperture Radar (PALSAR). This image was acquired in Fine Beam Dual mode, at 1.1 processing level on 2008-06-15, and is made avalilable after preprocessing, in aplitude format, polarizations HH (channel 1) and VH (channel 2), speckle filtered and with 15 m of pixel size.

Each index in the labeled raster represents a class:

1. BS
2. CA+IA
3. CP+SP
4. SV1+SV2+SV3
5. MA+MF


# 2010

Corresponds to the subset of an image from the satellite/sensor Landsat 5/ Thematic Mapper (TM). This images was acquired on 2010-06-29 and made available in surface reflectance, bands 4,5, and 7 (channels 1,2, and 3) and was geometric and radiometric corrected. These images were reamostrated to have a pixel size of 15 m.

Each index in the labeled raster represents a class:

1. IA
2. CA
3. MF
4. MA
5. CP
6. SP 
7. BS
8. SV1
9. SV2
10. SV3


# 2013

Corresponds to an subset of an image from the  satellite/sensor Earth Observer 1 (EO-1)/Advanced Land Imager (ALI). This image was acquired on 2013-10-05, and is made avalilable after preprocessing, bands 4', 5', and 7 (channels 1,2, and 3), with 15 m of pixel size.

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


