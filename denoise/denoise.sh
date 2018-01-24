#!/bin/sh
#use this script to scrub data using fmriprep parameters and output
#python script provided via https://github.com/arielletambini/denoiser
for i in {2001..2032}; do
	for r in 1 2; do
		if [ -f "fmriprep/sub-${i}/func/sub-${i}_task-TD_run-01_bold_space-MNI152NLin2009cAsym_preproc.nii.gz" ]; then
			input=fmriprep/sub-${i}/func/sub-${i}_task-TD_run-0${r}_bold_space-MNI152NLin2009cAsym_preproc.nii.gz
			confounds=fmriprep/sub-${i}/func/sub-${i}_task-TD_run-0${r}_bold_confounds.tsv
			if [ ! -d "denoise/sub-${i}" ]; then
				mkdir denoise/sub-${i}
			fi
			out_dir=denoise/sub-${i}
			echo "Running denoiser on subject ${i} run ${r}"
			echo "sub-${i}_run-0${r}">>${out_dir}/denoise_info.txt
			python denoise/denoiser/run_denoise.py --col_names CSF WhiteMatter stdDVARS FramewiseDisplacement X Y Z RotX RotY RotZ --out_figure_path ${out_dir}/figures_run0${r} ${input} ${confounds} ${out_dir}
			echo "Parameters denoised: CSF WhiteMatter stdDVARS FramewiseDisplacement X Y Z RotX RotY RotZ">>${out_dir}/denoise_info.txt
		fi
	done
done
