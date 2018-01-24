#!/bin/sh
#Uses BIDSto3col.sh script with line edit to grab the 12th column and create 3 column EV regressors for FSL
#J.Castrellon, Duke University, 12.2017

#create output directory
if [ ! -d "event_files" ]; then
	mkdir event_files
fi
ev=event_files

#loop through subjects & runs
for i in {2001..2032}; do	
	for r in 1 2; do
		if [ -f "trial_fits/${i}_0${r}_with_SV_parameters.csv" ]; then
			#make changes on a copy to be safe
			cp trial_fits/${i}_0${r}_with_SV_parameters.csv ${i}_0${r}_with_SV_parameters_copy.csv
			#convert csv to tsv
			tr "," "\t" < ${i}_0${r}_with_SV_parameters_copy.csv > ${ev}/sub-${i}_task-TD_run-0${r}_events.tsv;
			#delete the copy we just made
			rm ${i}_0${r}_with_SV_parameters_copy.csv
			
			#make 3 column EV file for FSL with the SV parameter of interest
			sh BIDSto3col.sh -s -h SV_chosen -d duration ${ev}/sub-${i}_task-TD_run-0${r}_events.tsv ${ev}/sub-${i}_task-TD_run-0${r}_SV_chosen;
			sh BIDSto3col.sh -s -h SV_sum -d duration ${ev}/sub-${i}_task-TD_run-0${r}_events.tsv ${ev}/sub-${i}_task-TD_run-0${r}_SV_sum;
			sh BIDSto3col.sh -s -h SV_diff -d duration ${ev}/sub-${i}_task-TD_run-0${r}_events.tsv ${ev}/sub-${i}_task-TD_run-0${r}_SV_diff;
			
		fi
	done
done