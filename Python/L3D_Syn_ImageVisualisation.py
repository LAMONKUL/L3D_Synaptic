import nilearn

pwd

from nilearn import image 
from nilearn.plotting import plot_roi
from nilearn import datasets

template = datasets.load_mni152_template(resolution = 1)

img_SV2AvsAge = image.load_img(r'pathname\SV2A_Age.nii')

plot_roi(img_SV2AvsAge, output_file = r'pathname\SVAPET_age.png', 
         cmap = 'YlOrRd_r', colorbar = True, bg_img = template, black_bg = False, display_mode = 'ortho')
