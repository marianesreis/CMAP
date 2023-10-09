# the Compound Maximum a Posteriori (CMAP) algorithm


CMAP incorporates the knowledge of land cover dynamics and the information of multi-temporal data sets to produce only valid land cover trajectories using a global generative classification approach and simple inputs. Consider that the user wants to classify an image time series into land cover classes. Each image corresponds to one time of interest in this time series to be classified. To use CMAP, the user needs:

1) The images that carry the observation indicative of each class at each time (images that are going to be classified);
2) Labeled samples of land cover classes of interest;
3) The a priori probability of each land cover trajectory.

The CMAP classification was organized in three steps, to allow for the easy modification of the process:

1) Calculation of the probability of classes given the observation;
2) Calculation of the a priori probability of trajectories;
3) Computation of CMAP and classification of results.

These codes are under revision and being made public accordingly. Preliminary versions of codes and input datasets may be made available conditioned to direct and reasonable requests. Please create an Issue (https://github.com/marianesreis/CMAP/issues) or contact me at mariane.reis@inpe.br for more information.

When using the algorithm, please cite the original paper:
M. S. Reis, L. V. Dutra, M. I. S. Escada, and S. J. S. Sant’anna, "Avoiding Invalid Transitions in Land Cover Trajectory Classification With a Compound Maximum a Posteriori Approach," in IEEE Access, vol. 8, pp. 98787-98799, 2020, doi: 10.1109/ACCESS.2020.2997019.

Please check the HTML in the files for a demonstration of the input dataset and an example of an R script to use CMAP.


Note: in CMAP, we aim to classify the trajectory $s=\{\omega^{k_1}_{1},..., \omega^{k_t}_{t},...,\omega^{k_T}_{T}\}$}. Here:

- $T$ = the length of the time sequence;
- $\omega^{k_t}_{t} \in \Omega_t = \{\omega^{k_1}_t, ..., \omega^{k_t}_{t},... \omega^{K_t}_{t} \}$;
- $\omega^{k_t}_t$ = the actual class at time position $t$ of $s$;
- $k_t$ = {the indicator of the class in the set} $\Omega_t$ that holds the $K_t$ possible classes on time $t$;
- $s\in \boldsymbol{\Omega} =\Omega_1 \otimes ... \otimes \Omega_t \otimes ... \otimes \Omega_T$;
- $\otimes$ = the Cartesian Product of sets.
- $\vec{X} = \{\vec{x_1},..., \vec{x_t},...,\vec{x_T}\}$ is a given observation vector that contains the $T$ temporal observations that can indicate the trajectory composition (e.g., the digital numbers in correspondent pixels in {a given set of images $\boldsymbol{X}$), and $\vec{X} \in \boldsymbol{X}$};
- $\hat{s} = \arg_s \max (P(\vec{X}|s) \times P(s), s \in \boldsymbol{\Omega}, \vec{X} \in \boldsymbol{X})$;
- $P(s)$ = the \textit{a priori} probability of a {trajectory} $s$;
- $P(\vec{X}|s) =  P(\vec{x_1}|\omega^{k_1}_{1}) \times ...\times P(\vec{x_t}|\omega^{k_t}_{t}) \times ... \times P(\vec{x_T}|\omega^{k_T}_{T}).$ 
(As we suppose that the observations are independent in time and that each one depends only on the observed object.)

