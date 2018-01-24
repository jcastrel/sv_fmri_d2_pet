#/usr/bin/env python
#use this script to create png plots of first & second-level FSL FEAT Z-stat & COPE maps for quick visual QA
import os
import glob
import nilearn
from nilearn.plotting import plot_stat_map, plot_glass_brain

#define study analysis directory
studydir = '/Volumes/CASTRELLON/selfreg'
#define QA output directory paths for first-level and second-level FEAT
qa_lev1_dir = "%s/analysis5/QA/lev1"%(studydir)
qa_lev2_dir = "%s/analysis5/QA/lev2"%(studydir)
#define first and second-level FEAT path pattern
lvl1_subdirs = glob.glob("%s/analysis5/sub-[0-9][0-9][0-9][0-9]/run-[0-9][0-9].feat"%(studydir))
lvl2_subdirs = glob.glob("%s/analysis5/sub-[0-9][0-9][0-9][0-9]/mean.gfeat/cope1.feat"%(studydir))
#make the file path name easier to work with
for dir in list(lvl1_subdirs):
    splitdir = dir.split('/')
    subname = splitdir[5]
    #subnum = subname[-4:]
    featdir = splitdir[6]
    featdir = featdir.split('.')
    runname = featdir[0]
#only make images for runs that exist
    if os.path.isfile("%s/stats/zstat1.nii.gz"%(dir)):
        zstat_map_file = "%s/stats/zstat1.nii.gz"%(dir)
        print(zstat_map_file)
        #simple stat map on centered coordinates (X,Y,Z)
        display = plot_stat_map(zstat_map_file, threshold=2.3, cut_coords=(0,0,0))
        display.savefig("%s/%s_%s_stat_map_zstat1_thr_2.3.png"%(qa_lev1_dir,subname,runname))
        display.close()
    if  os.path.isfile("%s/stats/cope1.nii.gz"%(dir)):
        cope_map_file = "%s/stats/cope1.nii.gz"%(dir)
        print(cope_map_file)
        #glass brain map
        display = plot_glass_brain(cope_map_file)
        display.savefig("%s/%s_%s_glass_brain_cope1_0thr.png"%(qa_lev1_dir,subname,runname))
        display.close()

#now do the same for the within subject mean maps        
for dir in list(lvl2_subdirs):
    splitdir = dir.split('/')
    subname = splitdir[5]
    if os.path.isfile("%s/stats/zstat1.nii.gz"%(dir)):
        zstat_map_file = "%s/stats/zstat1.nii.gz"%(dir)
        print(zstat_map_file)
        display = plot_stat_map(zstat_map_file, threshold=2.3, cut_coords=(0,0,0))
        display.savefig("%s/%s_stat_map_zstat1_thr_2.3.png"%(qa_lev2_dir,subname))
        display.close()
    if os.path.isfile("%s/stats/cope1.nii.gz"%(dir)):
        cope_map_file = "%s/stats/cope1.nii.gz"%(dir)
        print(cope_map_file)
        display = plot_glass_brain(cope_map_file)
        display.savefig("%s/%s_glass_brain_cope1_0thr.png"%(qa_lev2_dir,subname))
        display.close()
