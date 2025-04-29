
# Pipeline Overview

1. **SUVR Image Generation**:
   - SUVR image generation was fully automated using in-house scripts available at [https://github.com/THOMVDC/PSYPET](https://github.com/THOMVDC/PSYPET).
   - **MK6240** and **UCB-J PET** images: SUVR images were generated in *participant-specific space*. 
   - **Flutemetamol PET** images: SUVR images were generated in *MNI space*.

2. **Normalisation to MNI Space for Voxelwise Analysis**:  
  To enable voxelwise analysis in **SPM12**, SUVR images for MK6240 and UCB-J PET were normalised to MNI space using the `LCN12_PET_L3D_normalise.m` script.
  For **MK6240 PET**, partial volume correction (PVC) removed skull information, complicating direct warping. To address this:  
   - The **non-PVC MK6240 PET image** was used as an intermediary in the normalisation step.  
   - This step was performed using the `LCN12_PET_L3Dpreprocessing_MK.m` script prior to running the LCN12_PET_L3D_normalise.m for MK-6240.

3. **SUVR Calculation in VOIs**:  
  Composite SUVR values in volumes of interest (VOIs) were calculated using the `LCN12_calc_values_VOIS_L3D.m` script.
