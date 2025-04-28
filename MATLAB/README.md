Image processing was fully automated using in-house scripts (https://github.com/THOMVDC/PSYPET). 
This pipeline generated SUVR images in participant-specific space for MK6240 and UCB-J PET images. For flutemetamol the generated SUVR images were in MNI space. 
To enable voxelwise analysis in SPM12 the MK6240 and UCB-J SUVR images generated were normalised to MNI space using respectively LCN12_PET_L3D_MK.m and LCN12_PET_L3D_UCBJ.m. For MK6240 PET, the PVC corrected images did not contain skull information, which complicated warping. Therefore, the non-PVC MK6240 PET image was used in an intermediary step for normalisation of the PVC corrected images using LCN12_PET_L3Dpreprocessing_MK.m
LCN12_calc_values_VOIS_L3D.m was used to calculate composite SUVR values in the volumes of interest (


