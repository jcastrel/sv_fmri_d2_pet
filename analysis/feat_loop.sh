#!/bin/sh

#loop level 1
for i in {2001..2032}; do 
	for r in 1 2; do 
		if [ -f "feat_design_files/lvl_01/sub-${i}_run-0${r}_SV_CHOSEN_denoised_data_postRT.fsf" ]; then 
			echo "Running FSL FEAT on subject ${i} run 0${r}"; feat feat_design_files/lvl_01/sub-${i}_run-0${r}_SV_CHOSEN_denoised_data_postRT.fsf; 
		fi; 
	done; 
done
#loop level 2
for i in {2001..2032}; do
	if [ -f "feat_design_files/lvl_02/sub-${i}_SV_CHOSEN_denoised_data_lvl_02_postRT_mean.fsf" ]; then
		echo "Running 2nd-level FSL FEAT on subject ${i}";
		feat feat_design_files/lvl_02/sub-${i}_SV_CHOSEN_denoised_data_lvl_02_postRT_mean.fsf;
	fi;
done
