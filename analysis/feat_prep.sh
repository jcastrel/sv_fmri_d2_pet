#!/bin/sh
#Use this script to prep fmriprep'd lower-level FEAT data for higher-level analysis
#script usage "fmriprep_feat_prep.sh
subj=${1}
for run in 1 2; do
	if [ -d "sub-${subj}" ]; then
		subjDir=sub-${subj}
		featDir=${subjDir}/run-0${run}.feat
		fi

	#if higher level analysis was already run, we need to remove the reg_standard directory to prevent issues arising later on
	if [ -d "${featDir}/reg_standard" ]; then
		rm -r ${featDir}/reg_standard
	fi

	#remove pre-existing transformation files
	rm ${featDir}/reg/*.mat

	#Copy identity matrix to make sure data voxels don't change
	cp ${FSLDIR}/etc/flirtsch/ident.mat ${featDir}/reg/example_func2standard.mat

	#Copy the mean functional image to make sure we don't change space
	cp ${featDir}/mean_func.nii.gz ${featDir}/reg/standard.nii.gz
done