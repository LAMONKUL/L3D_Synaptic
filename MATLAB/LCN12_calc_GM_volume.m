% LCN12_calc_GM_volume.m
%
% This script will calculate the GM volume for two time points for the
% whole brain and in specific VOIS. Data are processed using a longitudinal
% pipeline.
%
% author: Patrick Dupont
% date: June 2021
% history:
%
% THIS IS RESEARCH SOFTWARE
%__________________________________________________________________________
% @(#)LCN12_calc_GM_volume.m               v0.1   last modified: 2021/06/16

datadir = 'D:\Projects\L3Dstudy\processing_CAT12';
subjectlist = {
'B002'
'B003'
'B004'
'B005'
'B006'
'B008'
'B009'
'B010'
'B011'
'B012'
'B013'
'B014'
'B015'
'B016'
'B017'
'B019'
'B020'
'B021'
'B023'
'B024'
'B026'
'B027'
'B028'
'B029'
'B030'
'B031'
'B032'
'B033'
'B034'
'B035'
'B036'
'B038'
'B040'
'B041'
'B042'
'B043'
'B045'
'B046'
'B047'
'B048'
'B049'
'B050'
'B051'
'B052'
'B053'
'B055'
'B056'
'B057'
'B059'
'B061'
'B063'
'B064'
'B065'
'B066'
'B067'
'B068'
'B069'
'B070'
'B072'
'B073'
'B074'
'B075'
'B076'
'B077'
'B079'
'B080'
'B081'
'B082'
};
name_dir1 = 'CAT12_PSYCH';
name_dir2 = 'CAT12_PSYCH';

template1 = 'mwp1accT1_B*.nii';
template2 = 'mwp1accT1_B*.nii';

VOIS = { 
% full filename of an image representing the VOI   threshold    VOIname
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\unadjusted\GFAP\GFAP_UCBJ_unadjustedVOI.nii' 0.3 'GFAP_GM_unadjustedVOI'
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\unadjusted\VAMP2\VAMP2_UCBJ_unadjustedVOI.nii' 0.3 'VAMP2_GM_unadjustedVOI'
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\unadjusted\NfL\NfL_UCBJ_unadjustedVOI.nii' 0.3 'NfL_GM_unadjustedVOI'
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\corrected\GFAP\GFAP_UCBJ_VOI_adjusted_correctreg.nii' 0.3 'GFAP_GM_adjustedVOI'
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\corrected\NfL\NfL_raw\NfL_UCBJ_VOIresult.nii'  0.3 'NfL_GM_adjustedVOI'
'D:\Projects\L3Dstudy\Analyses\CompleteCohort_N61\pet_trc-UCBJ\corrected\VAMP2\VAMP2_raw\VAMP2_UCBJ_VOI_adjusted_correctreg.nii'  0.3 'VAMP2_GM_adjustedVOI'
}; 

%+++++++++++++++++++ DO NOT CHANGE BELOW THIS LINE ++++++++++++++++++++++++
nr_subjects = size(subjectlist,1);
nr_VOIS     = size(VOIS,1);

for subj = 1:nr_subjects
    clear subjectcode dir1 dir2 dirlist1 dirlist2 GM1_filename GM2_filename 
    clear GM1 Vref GM2 tmp voxelsize GM1_values GM2_values delta_GM
    subjectcode = subjectlist{subj,1};
    dir1 = fullfile(fullfile(datadir,subjectcode),name_dir1);
    dir2 = fullfile(fullfile(datadir,subjectcode),name_dir2);
    
    go = 1;
    % get the GM maps
    cd(dir1)
    dirlist1 = dir(template1);
    if size(dirlist1,1) == 1
       GM1_filename = fullfile(dir1,dirlist1(1).name); 
    else
       go = 0;
       fprintf('no or multiple files found using the template %s in dir %s \n',template1,dir1);
    end
    cd(dir2)
    dirlist2 = dir(template2);
    if size(dirlist2,1) == 1
       GM2_filename = fullfile(dir2,dirlist2(1).name); 
    else
       go = 0;
       fprintf('no or multiple files found using the template %s in dir %s \n',template2,dir2);
    end
    
    if go == 1
       % read GM maps
       [GM1,Vref] = LCN12_read_image(GM1_filename);
       GM2 = LCN12_read_image(GM2_filename);
     
       % get the voxelsize
       tmp = spm_imatrix(Vref.mat);   % tmp(7:9) are the voxel sizes
       voxelsize = prod(abs(tmp(7:9)))/1000; % in cc

       fprintf('subjectcode \t VOIname \t GM1 volume (cc) \t GM2 volume (cc)\t delta GM (%%) \n');
       % calculate whole brain GM volumes
       GM1_values = sum(GM1(:));
       GM2_values = sum(GM2(:));
           
       delta_GM = 100*(GM1_values - GM2_values)./GM1_values;
       fprintf('%s \t whole brain \t %6.2f \t %6.2f \t %6.4f \n',subjectcode,voxelsize.*GM1_values,voxelsize.*GM2_values,delta_GM);
       for voi = 1:nr_VOIS
           clear voi_filename voi_threshold voi_name VOI_img VOI_mask 
           clear GM1_values GM2_values delta_GM
           voi_filename  = VOIS{voi,1};
           voi_threshold = VOIS{voi,2};
           voi_name      = VOIS{voi,3};
           % read VOI
           VOI_img = LCN12_read_image(voi_filename,Vref);
           VOI_mask = VOI_img > voi_threshold;
           
           GM1_values = sum(GM1(VOI_mask > 0));
           GM2_values = sum(GM2(VOI_mask > 0));
           
           delta_GM = 100*(GM1_values - GM2_values)./GM1_values;
           fprintf('%s \t %s \t %6.2f \t %6.2f \t %6.4f \n',subjectcode,voi_name,voxelsize.*GM1_values,voxelsize.*GM2_values,delta_GM);
       end
    end
end