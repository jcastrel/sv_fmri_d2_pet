#!/usr/bin/python

# This script will generate each subjects design.fsf, but does not run it.
# It depends on your system how will launch feat

import os
import glob

# Set this to the directory all of the sub### directories live in
studydir = '/Volumes/CASTRELLON/selfreg'

# Set this to the directory where you'll dump all the fsf files
# May want to make it a separate directory, because you can delete them all o
#   once Feat runs
fsfdir="%s/feat_design_files/lvl_01"%(studydir)

# Get all the paths!  Note, this won't do anything special to omit bad subjects
subdirs=glob.glob("%s/fmriprep/sub-[0-9][0-9][0-9][0-9]/func/sub-[0-9][0-9][0-9][0-9]_task-TD_run-[0-9][0-9]_bold_space-MNI152NLin2009cAsym_preproc.nii.gz"%(studydir))

for dir in list(subdirs):
  splitdir = dir.split('/')
  # YOU WILL NEED TO EDIT THIS TO GRAB sub001
  subnum = splitdir[5]
  subnum = subnum[-4:]
  #  YOU WILL ALSO NEED TO EDIT THIS TO GRAB THE PART WITH THE RUNNUM
  splitdir_run = splitdir[7]
  splitdir_run = splitdir_run[22]
  runnum=splitdir_run
  print(subnum)
  #ntime = os.popen('fslnvols %s/bold.nii.gz'%(dir)).read().rstrip()
  replacements = {'SUBNUM':subnum, 'RUNNUM':runnum}
  with open("%s/template_sv_diff_denoised_data_postRT.fsf"%(fsfdir)) as infile: 
    with open("%s/sub-%s_run-0%s_SV_DIFF_denoised_data_postRT.fsf"%(fsfdir, subnum, runnum), 'w') as outfile:
        for line in infile:
          # Note, since the video, I've changed "iteritems" to "items"
          # to make the following work on more versions of python
          #  (python 3 no longer has iteritems())  
          for src, target in replacements.items():
            line = line.replace(src, target)
          outfile.write(line)
  
