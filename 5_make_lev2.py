#!/usr/bin/python

# This creates the level1 fsf's and the script to run the feats on condor

import os
import glob

studydir = '/Volumes/CASTRELLON/selfreg'

fsfdir="%s/feat_design_files/lvl_02"%(studydir)


subdirs=glob.glob("%s/analysis3/sub-[0-9][0-9][0-9][0-9]"%(studydir))

for dir in list(subdirs):
  splitdir = dir.split('/')
  splitdir_sub = splitdir[5]  # You will need to edit this
  subnum=splitdir_sub[-4:]    # You also may need to edit this
  subfeats=glob.glob("%s/run-0[0-9].feat"%(dir))
  #if len(subfeats)==3:  # Add your own second loop for 2 feat cases
  print(subnum)
  replacements = {'SUBNUM':subnum}
  with open("%s/template_lvl_02_denoised_data_postRT_sv_diff.fsf"%(fsfdir)) as infile: 
      with open("%s/sub-%s_SV_DIFF_denoised_data_lvl_02_postRT_mean.fsf"%(fsfdir, subnum), 'w') as outfile:
          for line in infile:
              for src, target in replacements.iteritems():
                  line = line.replace(src, target)
                  outfile.write(line)
    
