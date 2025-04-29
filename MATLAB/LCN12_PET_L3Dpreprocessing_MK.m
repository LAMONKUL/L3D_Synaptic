% LCN12_PET_L3Dpreprocessing_MK.m
%
% assumptions: 
%	    Data are transformed to nifti format. 
%       Each subject has his own folder.
%       There is a folder data which contains the unprocessed nifti images. 
%           In this folder there are 3 subfolders MK, T1_MRI and metadata. 
%       PET data is a SUVR image
%       The origin of the PET and MRI data have been set to AC and if 
%       necessary the pitch (and yaw and roll) have been adapted so that 
%       the initial orientation is more similar to the templates in MNI.
%       
% Output: preprocessed data in MNI space + intermediate results
%
% author: Patrick Dupont - Adapted by Steffi De Meyer
% date: September 2023
% history: 
%
% THIS IS RESEARCH SOFTWARE
%__________________________________________________________________________
% @(#) Adapted from LCN12_PET_AV1451_AVID_preprocessing  v0.0   last modified: 2023/09/13

clear
close all

maindir = 'pathname'; % directory where the folders of each subject can  be found
processing_mainfolder = 'processing_*'; % in this directory the processed data will be written
name_PET_folder = 'pet_trc-*';

subject_list = {
    % name of the folder within the maindir
 's*'
};

%++++++++++++++++ DO NOT CHANGE BELOW THIS LINE +++++++++++++++++++++++++++
cd(maindir)
% determine the path of the prior data of SPM
tmp = which('spm.m');
[spm_pth,~,~]  = fileparts(tmp);
spm_pth_priors = fullfile(spm_pth,'tpm');

if exist(processing_mainfolder,'dir') ~= 7
   mkdir(processing_mainfolder);
end
    
nr_subjects = size(subject_list,1);
for subj = 1:nr_subjects
    clearvars -except subj nr_subjects spm_pth_priors spm_pth maindir ...
                      processing_mainfolder infostring_MRI infostring_PET ...
                      infostring_meta name_PET_folder subject_list interval ref_VOI...
                      threshold_rotation threshold_translation frames_timing GM_threshold
    
    subjectfolder_name = subject_list{subj,1};
    subjectfolder_new = fullfile(maindir,fullfile(processing_mainfolder,subjectfolder_name));
    datadir_PET       = fullfile(subjectfolder_new,name_PET_folder);
    datadir_MRI       = fullfile(subjectfolder_new,'T1_MRI'); % changed from 'anat' to match own file names
    datadir_anat      = fullfile(fullfile(subjectfolder_new,name_PET_folder),'anat');
    datadir_tmp       = fullfile(fullfile(subjectfolder_new,name_PET_folder),'tmp');
    datadir_batch     = fullfile(fullfile(subjectfolder_new,name_PET_folder),'batch');
    
    % check if the data are already preprocessed by checking if there exist
    % a folder with the same name in the folder processing_mainfolder
    cd(maindir)
    cd(processing_mainfolder)
    
    if exist(datadir_PET,'dir') == 7
       fprintf('PET folder %s already exists. Assuming already preprocessed. \n',datadir_PET);
    else
       % copy the data to the processing folder
       %+++++++++++++++++++++++++++++++++++++++
       fprintf('start preprocessing of subject %s \n',subjectfolder_name);
       fprintf('copying data of subject %s to the preprocessing folder %s \n',subjectfolder_name,processing_mainfolder);
       mkdir(datadir_MRI);
       copyfile(fullfile(fullfile(fullfile(maindir,subjectfolder_name),'data'),'T1_MRI'),datadir_MRI); % changed from MRI to T1_MRI to match own folder names
       copyfile(fullfile(fullfile(fullfile(maindir,subjectfolder_name),'data'),name_PET_folder),datadir_PET);

       cd(subjectfolder_new)
       name_logfile = fullfile(datadir_PET,'L3D_preprocessing_MK.txt');
       fid  = fopen(name_logfile,'a+');
       fprintf(fid,'subject = %s\n',subjectfolder_new);
       fprintf(fid,'LCN12_PET_L3D.m \n'); %changed to name of current script
       fprintf(fid,'%c','-'*ones(1,30));
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Processing started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       fprintf(fid,'\n');
       fprintf(fid,'Settings\n');
      
       % create the subdirectories we need
       mkdir(datadir_tmp)
       mkdir(datadir_anat)
       mkdir(datadir_batch)
    
        nr_frames = 1

       fprintf('...initializing SPM \n');
       matlabbatch = {};
       spm_jobman('initcfg')

       % determine the list of all PET frames
       %+++++++++++++++++++++++++++++++++++++
       cd(name_PET_folder)
       Pdy = {};
       filelist = dir('SUVR*.nii'); %Changed from SUMPET*.nii since SUVR image has already been created in this case     
       nr_frames_dy = size(filelist,1);
       if nr_frames_dy ~= nr_frames
          fprintf('ERROR subject %s: total number of frames is not consistent with the frame defintion file\n',subjectfolder_name);
          return;
       else
          for frame = 1
              % rename frame
              new_filename = ['SUVR_MK_' num2str(frame) '.nii']; %Changed new name to SUVR_MK from fu_ 
              movefile(filelist(frame).name,new_filename)
              Pdy{frame} = fullfile(datadir_PET,[new_filename ',1']);
          end
       end    
       fprintf(fid,'Scans: \n');
       for frame = 1:nr_frames
           fprintf(fid,'frame %i \t %s\n',frame,char(Pdy(frame)));
       end
       fprintf(fid,'\n');
    
       % read last frame to obtain image size
       Vref      = spm_vol(char(Pdy(nr_frames)));

       filelist = {};
       for i = 1:nr_frames
           filelist{i,1} = char(Pdy{i});
       end        
       
       close all


      filename_mean = fullfile('SUVR_MK_1.nii'); %Changed this from datadir_PET,filelist(1).name since I now only have 1 PET frame (SUVR image) and this code did not asign a value to the variable
      
       % coregister the PET and MRI
       %+++++++++++++++++++++++++++
       cd(datadir_MRI)
       filelist = dir('acc*.nii'); % Changed from 's*.nii' to match current filename
       if size(filelist,1) ~= 1
          fprintf('ERROR subject %s: no or more than one structural scan found \n',subjectfolder_name);
          return;
       else
          filename = filelist(1).name;
          new_filename = '3DT1.nii';
          movefile(filename,new_filename)
          ref_image = fullfile(datadir_anat,new_filename);
          copyfile(fullfile(datadir_MRI,new_filename),ref_image);  
       end
       
       source_image = filename_mean;
       
       % generate the batch file 
       fprintf('...creating the coregister batchfile for subject %s\n',subjectfolder_name);
       matlabbatch = {};
       matlabbatch{1}.spm.spatial.coreg.estimate.ref = cellstr(ref_image);
       matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(source_image);
       matlabbatch{1}.spm.spatial.coreg.estimate.other = filelist;
       matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
       matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
       matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
       matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
       cd(datadir_batch)
       save batch_coregister matlabbatch
       cd(datadir_PET)
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Coregistration started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       % run batchfile
       spm_jobman('run',matlabbatch)
       tmp  = clock;
       fprintf(fid,'Coregistration ended at: %i h %i min %i s\n',tmp(4), tmp(5),round(tmp(6)));

       % segment the MRI (which will also generate the warping to MNI)
       %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
       matlabbatch = struct([]);
       matlabbatch{1}.spm.spatial.preproc.channel.vols = cellstr([ref_image ',1']);
       matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
       matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
       matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
       matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,1'));
       matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
       matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,2'));
       matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
       matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,3'));
       matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
       matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,4'));
       matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
       matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,5'));
       matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
       matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = cellstr(fullfile(spm_pth_priors,'TPM.nii,6'));
       matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
       matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
       matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
       matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
       matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
       matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
       matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
       matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
       matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
       matlabbatch{1}.spm.spatial.preproc.warp.write = [1 1];
       cd(datadir_batch)
       save batch_segment matlabbatch
       cd(datadir_PET)
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Segmentation started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       % run batchfile
       spm_jobman('run',matlabbatch)
       tmp  = clock;
       fprintf(fid,'Segmentation ended at: %i h %i min %i s\n',tmp(4), tmp(5),round(tmp(6)));
    
       % apply the warping parameters to the PET data
       %+++++++++++++++++++++++++++++++++++++++++++++
       [pth,filename,~] = fileparts(ref_image);
       deformation_field = fullfile(pth,['y_' filename '.nii']);
       fprintf('...creating the warping batchfile for subject %s\n',subjectfolder_name);
       matlabbatch = {};
       matlabbatch{1}.spm.spatial.normalise.write.subj.def = cellstr(deformation_field);
       matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(source_image); %changed from filelist because this generated an empty field in batch file
       matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                               78   76  85];
       matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
       matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
       cd(datadir_batch)
       save batch_warping_PET matlabbatch
       cd(datadir_PET)
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Warping PET started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       % run batchfile
       spm_jobman('run',matlabbatch)
       tmp  = clock;
       fprintf(fid,'Warping PET ended at: %i h %i min %i s\n',tmp(4), tmp(5),round(tmp(6)));
    
       % apply the warping parameters to the GM and WM images
       %+++++++++++++++++++++++++++++++++++++++++++++++++++++   
       fprintf('...creating the warping batchfile for subject %s\n',subjectfolder_name);
       filelistMRI = {};
       filelistMRI{1,1} = fullfile(pth,['c1' filename '.nii,1']); % GM
       filelistMRI{2,1} = fullfile(pth,['c2' filename '.nii,1']); % WM
       filelistMRI{3,1} = fullfile(pth,['c3' filename '.nii,1']); % CSF
       filelistMRI{4,1} = fullfile(pth,['m' filename '.nii,1']); % bias corrected MRI
       matlabbatch = {};
       matlabbatch{1}.spm.spatial.normalise.write.subj.def = cellstr(deformation_field);
       matlabbatch{1}.spm.spatial.normalise.write.subj.resample = filelistMRI;
       matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                                                                  78   76  85];
       matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
       matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
       cd(datadir_batch)
       save batch_warping_GM_WM_CSF matlabbatch
       cd(datadir_PET)
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Warping segmentations started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       % run batchfile
       spm_jobman('run',matlabbatch)
       tmp  = clock;
       fprintf(fid,'Warping segmentations ended at: %i h %i min %i s\n',tmp(4), tmp(5),round(tmp(6)));
        
       % close log file
       %---------------    
       fclose(fid);
    end
end
