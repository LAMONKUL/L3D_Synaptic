% LCN12_calc_values_VOIS.m.m
%
%
% This script will calculate the values (mean, min, max, ...) in a set of
% VOIS for a set of images.
% assumptions: 
%       all VOI images and all images are in the same space (typically MNI)
%
% Output:
%       an excel file with all values and a log file
%
% author: Patrick Dupont
% date: July 2019
% history:
%
% THIS IS RESEARCH SOFTWARE
%__________________________________________________________________________
% @(#)LCN12_calc_values_VOIS.m      v0.1          last modified: 2019/07/12

clear
close all

%------------- SETTINGS ---------------------------------------------------
name_logfile  = 'pathname\SUVR_values_*_VOI.txt';

name_excel    = 'pathname\SUVR_values_*_VOI.xls'


brain_mask_file = 'pathname\AAL3_cerebrumMASK.nii'

use_GM_info  = 0; % if 0, the whole VOI within the brain mask will be taken. Otherwise only GM voxels within the VOI will be used.
GM_threshold = 0.3; % threshold to determing the GM voxels of that subject. Only needed if use_GM_info = 1

IMAGELIST = {
    % full name of the images                       full name of the GM map (optional)
'pathname\wSUVR_MK_1.nii' 
};
% if VOIS are specified, we assume that each VOI image represents a
% specific VOI and this will be used. If VOIS is not specified, we assume
% that ATLAS is specified. In that case, we assume that you want the values
% for each parcel in the atlas. The name of the parcel is the intensity 
% value of the atlas and you have to make the translation to the real name.
% In the future, we can read a .m file with this information.

VOIS = {
    % full name of the VOI images
'pathname\GFAP_UCBJmask.nii'
};

%------------- END OF SETTINGS --------------------------------------------

curdir = pwd;
fid  = fopen(name_logfile,'a+');
fprintf(fid,'LCN12_calc_values_VOIS.m \n');
fprintf(fid,'%c','-'*ones(1,30));
fprintf(fid,'\n');
fprintf(fid,'settings\n');
fprintf(fid,'brain_mask_file = %s\n',brain_mask_file);
fprintf(fid,'use_GM_info     = %i\n',use_GM_info);
if use_GM_info == 1
   fprintf(fid,'GM threshold = %i\n',GM_threshold);
end
fprintf(fid,'\n');
tmp  = clock;
fprintf(fid,'Date:         %s at %i h %i min\n',date,tmp(4), tmp(5));
fprintf(fid,'\n');

nr_subjects = size(IMAGELIST,1);

if exist('VOIS','var') == 1
   fprintf(fid,'VOIS \n');
   fprintf(fid,'-----\n');
   nr_VOIS = size(VOIS,1);
   for voi = 1:nr_VOIS
       fprintf(fid,'%s \n',char(VOIS{voi}));
   end
elseif exist('ATLAS','var') == 1
   fprintf('Atlas = %s \n',ATLAS);
   atlas_img = round(LCN12_read_image(ATLAS));
   parcel_values_orig = unique(atlas_img(atlas_img>0));
   nr_VOIS = length(parcel_values_orig);
   fprintf(fid,'number of parcels in atlas found = %i \n',nr_VOIS);
end

% initialize
results_mean      = cell(nr_subjects+1,nr_VOIS+1);
results_median    = cell(nr_subjects+1,nr_VOIS+1);
results_min       = cell(nr_subjects+1,nr_VOIS+1);
results_max       = cell(nr_subjects+1,nr_VOIS+1);
results_std       = cell(nr_subjects+1,nr_VOIS+1);
results_nr_voxels = cell(nr_subjects+1,nr_VOIS+1);

% make the header line
%---------------------
results_mean{1,1}      = 'subject\VOI';
results_median{1,1}    = 'subject\VOI';
results_min{1,1}       = 'subject\VOI';
results_max{1,1}       = 'subject\VOI';
results_std{1,1}       = 'subject\VOI';
results_nr_voxels{1,1} = 'subject\VOI';

if exist('VOIS','var') == 1
   for voi = 1:nr_VOIS
       results_mean{1,voi+1}      = char(VOIS{voi});
       results_median{1,voi+1}    = char(VOIS{voi});
       results_min{1,voi+1}       = char(VOIS{voi});
       results_max{1,voi+1}       = char(VOIS{voi});
       results_std{1,voi+1}       = char(VOIS{voi});
       results_nr_voxels{1,voi+1} = char(VOIS{voi});
   end
elseif exist('ATLAS','var') == 1
   for voi = 1:nr_VOIS
       results_mean{1,voi+1}      = ['VOI ' num2str(parcel_values_orig(voi))];
       results_median{1,voi+1}    = ['VOI ' num2str(parcel_values_orig(voi))];
       results_min{1,voi+1}       = ['VOI ' num2str(parcel_values_orig(voi))];
       results_max{1,voi+1}       = ['VOI ' num2str(parcel_values_orig(voi))];
       results_std{1,voi+1}       = ['VOI ' num2str(parcel_values_orig(voi))];
       results_nr_voxels{1,voi+1} = ['VOI ' num2str(parcel_values_orig(voi))];
   end
end

for subj = 1:nr_subjects
    clear filename filename_GM Vref img
    
    fprintf('working on subject %i of %i \n',subj,nr_subjects);
    % read images
    filename = char(IMAGELIST(subj,1));
    [img,Vref] = LCN12_read_image(filename);
    tmp = spm_imatrix(Vref.mat);   % tmp(7:9) are the voxel sizes
    voxel_size = abs(tmp(7:9));
    results_mean{subj+1,1}      = filename;
    results_median{subj+1,1}    = filename;
    results_min{subj+1,1}       = filename;
    results_max{subj+1,1}       = filename;
    results_std{subj+1,1}       = filename;
    results_nr_voxels{subj+1,1} = filename;
    if use_GM_info == 1
       filename_GM = char(IMAGELIST(subj,2));
       GMimg = LCN12_read_image(filename_GM,Vref);
    end
    brain_mask_img = LCN12_read_image(brain_mask_file,Vref);

    if use_GM_info == 1
       fprintf(fid,'image = %s \t GM = %s\n',filename,filename_GM);
    else
       fprintf(fid,'image = %s\n',filename);
    end
    
    if exist('VOIS','var') == 1
       % read VOIS
       for voi = 1:nr_VOIS
           voi_img = LCN12_read_image(char(VOIS{voi}),Vref);
           eval(['VOI_' num2str(voi) ' = voi_img;']);
       end
    elseif exist('ATLAS','var') == 1
       atlas_img = round(LCN12_read_image(ATLAS,Vref));
       parcel_values = unique(atlas_img(atlas_img>0));
    end
    fprintf('reading data of subject %i ... done\n',subj);
     
    % calculate values in the VOIS/parcels
    fprintf(fid,'VOI \t mean \t median \t min \t max \t std \t nr_voxels \n');
    fprintf('VOI \t mean \t median \t min \t max \t std \t nr_voxels \n');
    for voi= 1:nr_VOIS
        clear DVRmean DVRmedian DVRstd VOIimg tmp
        if exist('VOIS','var') == 1
           eval(['VOIimg = VOI_' num2str(voi) ';']);
           fprintf(fid,'%s \t',char(VOIS{voi}));
           fprintf('%s \t',char(VOIS{voi}));
           outputvoi = voi;
        elseif exist('ATLAS','var') == 1
            VOIimg = (atlas_img == parcel_values(voi));
            fprintf(fid,'VOI %i \t',parcel_values(voi));
            fprintf('VOI %i \t',parcel_values(voi));
            outputvoi = find(parcel_values_orig == parcel_values(voi));
        end
        if use_GM_info == 1
           VOI_mask = (VOIimg > 0.5).*(brain_mask_img > 0.5).*(GMimg > GM_threshold);
        else
           VOI_mask = (VOIimg > 0.5).*(brain_mask_img > 0.5);            
        end
        tmp = img(VOI_mask > 0);
        img_mean       = nanmean(tmp(:));
        img_median     = nanmedian(tmp(:));
        img_max        = nanmax(tmp(:));
        img_min        = nanmin(tmp(:));
        img_std        = nanstd(tmp(:));
        img_nr_voxels  = sum(VOI_mask(:)>0);
        
        results_mean{subj+1,outputvoi+1}      = img_mean;
        results_median{subj+1,outputvoi+1}    = img_median;
        results_min{subj+1,outputvoi+1}       = img_min;
        results_max{subj+1,outputvoi+1}       = img_max;
        results_std{subj+1,outputvoi+1}       = img_std;
        results_nr_voxels{subj+1,outputvoi+1} = img_nr_voxels;

        fprintf(fid,'\t %6.3f',img_mean);
        fprintf(fid,'\t %6.3f',img_median);
        fprintf(fid,'\t %6.3f',img_min);
        fprintf(fid,'\t %6.3f',img_max);
        fprintf(fid,'\t %6.3f',img_std);
        fprintf(fid,'\t %i\n',img_nr_voxels);
        
        fprintf('\t %6.3f',img_mean);
        fprintf('\t %6.3f',img_median);
        fprintf('\t %6.3f',img_min);
        fprintf('\t %6.3f',img_max);
        fprintf('\t %6.3f',img_std);
        fprintf('\t %i\n',img_nr_voxels);
    end
    fprintf(fid,'++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n');
end

% close log file
fclose(fid);

% write results to outputfile (excel)
xlswrite(name_excel,results_nr_voxels,'nr_voxels in VOI');
xlswrite(name_excel,results_mean,'mean');
xlswrite(name_excel,results_median,'median');
xlswrite(name_excel,results_max,'max');
xlswrite(name_excel,results_min,'min');
xlswrite(name_excel,results_std,'std');
