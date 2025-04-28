% LCN12_PET_L3D.m
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

% interval = [90 110]; % in min. for SUVR
% ref_VOI = {
% 'C:\Users\u0115549\Documents\01_Projects\04_NP22-07-VUmc\Analysis\Matlab_scripts\VOIs\resl_to_wmc1_SPM12_aal_whole_cerebellum.img'
%     0.5;
%     'Whole_Cerebellum'
% };
% 
% GM_threshold = 0.3;

maindir = 'D:\Projects\L3Dstudy\'; % directory where the folders of each subject can  be found
processing_mainfolder = 'processing_UCBJ'; % in this directory the processed data will be written
name_PET_folder = 'pet_trc-UCBJ';

subject_list = {
    % name of the folder within the maindir
% 'B002'
% 'B003'
% 'B004'
% 'B005'
% 'B006'
% 'B008'
% 'B009'
% 'B010'
% 'B011'
% 'B012'
% 'B013'
% 'B014'
% 'B015'
% 'B016'
% 'B017'
% 'B019'
% 'B020'
% 'B021'
% 'B023'
% 'B024'
% 'B025'
% 'B026'
% 'B027'
% 'B028'
% 'B029'
% 'B030'
% 'B031'
% 'B032'
% 'B033'
% 'B034'
% 'B035'
% 'B038'
% 'B040'
% 'B042'
% 'B043'
% 'B045'
% 'B046'
% 'B047'
% 'B048'
% 'B049'
% 'B050'
% 'B051'
% 'B052'
% 'B053'
% 'B055'
% 'B056'
% 'B057'
% 'B059'
% 'B066'
% 'B069'
% 'B070'
% 'B073'
% 'B074'
% 'B075'
% 'B077'
%'B080'
'B081'
'B082'
};

% frames_timing = [
%     % start time in s pi    end time in s pi    weight (optional)
%       5400                    6600                
%             
% ];
% 
% threshold_rotation    = 5; % in degrees
% threshold_translation = 5; % in mm
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
    datadir_MRI       = fullfile(subjectfolder_new,'anat'); % changed from 'anat' to match own file names
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
       copyfile(fullfile(fullfile(fullfile(maindir,subjectfolder_name),'ses-01'),'anat'),datadir_MRI); % changed from MRI to T1_MRI to match own folder names
       copyfile(fullfile(fullfile(fullfile(maindir,subjectfolder_name),'ses-01'),name_PET_folder),datadir_PET);

       cd(subjectfolder_new)
       name_logfile = fullfile(datadir_PET,'L3D_preprocessing_UCBJ.txt');
       fid  = fopen(name_logfile,'a+');
       fprintf(fid,'subject = %s\n',subjectfolder_new);
       fprintf(fid,'LCN12_PET_L3D.m \n'); %changed to name of current script
       fprintf(fid,'%c','-'*ones(1,30));
       fprintf(fid,'\n');
       tmp  = clock;
       fprintf(fid,'Processing started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
       fprintf(fid,'\n');
       fprintf(fid,'Settings\n');
%        fprintf(fid,'threshold (overall translation in mm)   = %4.2f \n',threshold_translation);
%        fprintf(fid,'threshold (overall rotation in degrees) = %4.2f \n',threshold_rotation);
%         
       % create the subdirectories we need
       mkdir(datadir_tmp)
       mkdir(datadir_anat)
       mkdir(datadir_batch)
    
        nr_frames = 1
%        % calculate midscan times (in minutes)
%        acqtimes = frames_timing(:,1:2)/60; % in minutes

       fprintf('...initializing SPM \n');
       matlabbatch = {};
       spm_jobman('initcfg')

       % determine the list of all PET frames
       %+++++++++++++++++++++++++++++++++++++
       cd(name_PET_folder)
       Pdy = {};
       filelist = dir('SUVR_PVC*.nii'); %Changed from SUMPET*.nii since SUVR image has already been created in this case     
       nr_frames_dy = size(filelist,1);
       if nr_frames_dy ~= nr_frames
          fprintf('ERROR subject %s: total number of frames is not consistent with the frame defintion file\n',subjectfolder_name);
          return;
       else
          for frame = 1
              % rename frame
              new_filename = ['SUVR_UCBJ_' num2str(frame) '.nii']; %Changed new name to SUVR_MK from fu_ (not sure what this stands for)
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
       
%        % realign the images
%        %+++++++++++++++++++
%        fprintf('...creating the realign batchfile for subject %s\n',subjectfolder_name);
%        matlabbatch = {};
%        matlabbatch{1}.spm.spatial.realign.estimate.data = {filelist}';
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 1;
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
%        matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = '';
%        cd(datadir_batch)
%        save batch_realign matlabbatch
%        cd(datadir_PET)
%        fprintf(fid,'\n');
%        tmp  = clock;
%        fprintf(fid,'Realignment started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
%        
%        % run batchfile
%        spm_jobman('run',matlabbatch)
%        tmp  = clock;
%        fprintf(fid,'Realignment ended at: %i h %i min %i s\n',tmp(4), tmp(5),round(tmp(6)));
% 
%        % display realignment parameters and determine bad volumes
%        %+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%        filelist_rp = dir('rp_*.txt');
%        if size(filelist_rp,1) ~= 1
%           fprintf('ERROR subject %s: more than 1 realignment file (rp_*.txt) found\n',subjectfolder_name);
%        end
%        rp_file = filelist_rp(1).name;
%        %bad_volumes = LCN12_analyze_headmovement_PET(rp_file,threshold_translation,threshold_rotation);    
% 
%        %bad_frames = bad_volumes;
%        %save bad_frames bad_frames
%        
%       % index_ok = setdiff([1:nr_frames],bad_frames);
%       % filelist_ok = filelist(index_ok);
%        matlabbatch = {};
%        matlabbatch{1}.spm.spatial.realign.write.data = filelist;
%        matlabbatch{1}.spm.spatial.realign.write.roptions.which = [0 1];
%        matlabbatch{1}.spm.spatial.realign.write.roptions.interp = 4;
%        matlabbatch{1}.spm.spatial.realign.write.roptions.wrap = [0 0 0];
%        matlabbatch{1}.spm.spatial.realign.write.roptions.mask = 1;
%        matlabbatch{1}.spm.spatial.realign.write.roptions.prefix = 'r';
% 
%        % run batchfile
%        spm_jobman('run',matlabbatch)
%        
%        filelist = dir('SUVR*.nii');
%        if size(filelist,1) ~= 1
%           fprintf('ERROR subject %s: no or more than one mean image found\n',subjectdir);
%           return;
%       end
      filename_mean = fullfile('SUVR_UCBJ_1.nii'); %Changed this from datadir_PET,filelist(1).name since I now only have 1 PET frame (SUVR image) and this code did not asign a value to the variable
% 
%        % read all images to generate an image for quality checking
%        %++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%       img4D = zeros(Vref(1).dim(1),Vref(1).dim(2),Vref(1).dim(3),nr_frames);
%        for i = 1:nr_frames
%          [img,~] = LCN12_read_image(char(Pdy(i)),Vref);
%           img4D(:,:,:,i) = img;
%        end
%        qcimg1 = squeeze(img4D(:,,round(Vref(1).dim(3)/2),:));
%        filename_qc1 = fullfile(datadir_PET,'qc1.nii');
%        LCN12_write_image(qcimg1,filename_qc1,'qc image');        
%        qcimg2 = squeeze(img4D(:,round(Vref(1).dim(2)/2),:,:));
%        filename_qc2 = fullfile(datadir_PET,'qc2.nii');
%        LCN12_write_image(qcimg2,filename_qc2,'qc image');        
%        qcimg3 = squeeze(img4D(round(Vref(1).dim(1)/2),:,:,:));
%        filename_qc3 = fullfile(datadir_PET,'qc3.nii');
%        LCN12_write_image(qcimg3,filename_qc3,'qc image');        
%        clear img4D
%     
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
       
%        filelist = {};
%        for i = 1:nr_frames
%            filelist{i,1} = char(Pdy{i});
%        end
       % genarate the batch file 
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
    
%        % cleaning directories and moving data
%        %+++++++++++++++++++++++++++++++++++++
%        fprintf(fid,'cleaning directory\n');
%        cd(datadir_PET)
%        movefile(fullfile(datadir_PET,'qc1.nii'),fullfile(datadir_tmp,'qc1.nii'));
%        movefile(fullfile(datadir_PET,'qc2.nii'),fullfile(datadir_tmp,'qc2.nii'));
%        movefile(fullfile(datadir_PET,'qc3.nii'),fullfile(datadir_tmp,'qc3.nii'));
%        tmp = dir('mean*.nii');
%        movefile(fullfile(datadir_PET,tmp(1).name),fullfile(datadir_tmp,tmp(1).name));
%        for i = 1:nr_frames
%            [pth,name,ext,~] = spm_fileparts(char(Pdy(i)));
%            movefile(fullfile(datadir_PET,fullfile([name ext])),fullfile(datadir_tmp,fullfile([name ext]))); 
%        end
%        movefile(fullfile(datadir_anat,'wc*'),datadir_PET); 
%        movefile(fullfile(datadir_anat,'wm*'),datadir_PET);    
%        fclose(fid);
%        
%        % generate SUVR image
%        %++++++++++++++++++++
%        reference_name       = char(ref_VOI(3,1));
%        SUVR_start_time      = interval(1); % in min
%        SUVR_end_time        = interval(2); % in min
%        outputname_log = fullfile(datadir_PET,['SUVR_' reference_name '_' num2str(SUVR_start_time) 'min_' num2str(SUVR_end_time) 'min_log.txt']);
%        fid = fopen(outputname_log,'a+');
% 
%        ref_VOI_file         = char(ref_VOI(1,1));
%        threshold_ref_VOI    = cell2mat(ref_VOI(2,1)); 
%        brain_mask_file = 'not specified';
%        
%        tmp_GM = dir('wc1*.nii');
%        filename_GM = fullfile(datadir_PET,tmp_GM(1).name);
%        VOI_mask = {
%            filename_GM;
%            GM_threshold;
%               };
%        VOI_mask_file        = char(VOI_mask(1,1));
%        threshold_VOI_mask   = cell2mat(VOI_mask(2,1));
% 
%        % write info to log file
%        %-----------------------
%        fprintf(fid,'%c','-'*ones(1,30));
%        fprintf(fid,'\n');
%        tmp  = clock;
%        fprintf(fid,'Processing started: %s at %i h %i min %i s\n',date,tmp(4), tmp(5),round(tmp(6)));
%        fprintf(fid,'\n');
%        fprintf(fid,'Settings\n');
%        fprintf(fid,'reference VOI = %s\n',ref_VOI_file);
%        fprintf(fid,'reference VOI threshold = %4.2f\n',threshold_ref_VOI);
%        fprintf(fid,'reference VOI short name = %s\n',reference_name);
%        fprintf(fid,'SUVR_start_time = %i min \n',SUVR_start_time);
%        fprintf(fid,'SUVR_end_time = %i min \n',SUVR_end_time);
%        fprintf(fid,'global mask   = %s\n',brain_mask_file);
%        fprintf(fid,'VOI mask      = %s\n',VOI_mask_file);
%        fprintf(fid,'VOI mask threshold  = %4.2f\n',threshold_VOI_mask);
%        first_frame = 1;
%        last_frame  = 1;
%        fprintf(fid,'number of frames = %i\n',nr_frames);
%        fprintf(fid,'first frame for SUVR calculation = %i\n',first_frame);
%        fprintf(fid,'last frame for SUVR calculation  = %i\n',last_frame);
% 
%        clear Vref
%        Pdy = {};
%        filelist = dir('wPETframe*.nii');       
%        nr_frames_dy = size(filelist,1);
%        if nr_frames_dy ~= nr_frames
%           fprintf('ERROR subject %s: total number of frames is not consistent with the frame defintion file\n',subjectfolder_name);
%           return;
%        else
%           for frame = 1:nr_frames
%               Pdy{frame} = fullfile(datadir_PET,[filelist(frame).name ',1']);
%           end
%        end    
%        fprintf(fid,'Scans: \n');
%        for frame = 1:nr_frames
%            fprintf(fid,'frame %i \t %s\n',frame,char(Pdy(frame)));
%        end
%        fprintf(fid,'\n');
%     
%        % read last frame to obtain image size
%        Vref      = spm_vol(char(Pdy(nr_frames)));
%               
%        % read reference VOI
%        refVOIimg = LCN12_read_image(ref_VOI_file,Vref);
%     
%        % read dynamic data
%        dydata = zeros(Vref.dim(1),Vref.dim(2),Vref.dim(3),nr_frames);
%        for frame = 1:nr_frames
%            clear tmp
%            tmp = LCN12_read_image(char(Pdy{frame}),Vref);
%            dydata(:,:,:,frame) = tmp/1000; %in kBq/ml
%        end
% 
%        % read VOI mask
%        VOI_mask_img = LCN12_read_image(VOI_mask_file,Vref);
%        ref_VOI_mask = (VOI_mask_img > threshold_VOI_mask);
%        brain_mask = ones(size(refVOIimg));
% 
%        % construct final reference VOI
%        %------------------------------
%        ref_mask = (refVOIimg > threshold_ref_VOI).*brain_mask.*ref_VOI_mask;
%        outputname_ref_VOI = fullfile(datadir_PET,['SUVR_' reference_name '_' num2str(SUVR_start_time) 'min_' num2str(SUVR_end_time) 'min_refVOI.nii']);
%        LCN12_write_image(ref_mask,outputname_ref_VOI,'SUVR',2,Vref);        
% 
%        % get the reference value for SUVR
%        %---------------------------------
%        ref_value = 0;
%        for frame = first_frame:last_frame
%           clear tmp
%           tmp = squeeze(dydata(:,:,:,frame));
%           ref_value = ref_value + nanmean(tmp(ref_mask>0));
%        end
%        ref_value = ref_value/(last_frame-first_frame+1);
% 
%        % calculate SUVR 
%        %---------------
%        sSUVR = squeeze(mean(dydata(:,:,:,first_frame:last_frame),4))./ref_value;
%        outputname_SUVR = fullfile(datadir_PET,['SUVR_' reference_name '_' num2str(SUVR_start_time) 'min_' num2str(SUVR_end_time) 'min.nii']);
%        LCN12_write_image(sSUVR,outputname_SUVR,'SUVR',Vref.dt(1),Vref);        
%        
%         
       % close log file
       %---------------    
       fclose(fid);
    end
end