Series of steps to go from raw delay discounting data to BIDS tsv files and FSL EV
files with subjective values derived using the hyperbolic discount function  

All scripts can be run from the behavioral_data directory

1. Adjust line 113 of discounting_Hyperbolic.py to set the
directory containing the list of csv files with each subjects' data.
 
2. Adjust line 114 of discounting_Hyperbolic.py to read the
column headers for smaller-sooner reward, larger-later reward,
and their respective delays. Remember, counting begins at zero.

3. Adjust line 146 of the discounting_Hyperbolic.py to set the output
directory. A single file containing each subjects' k-values, slope,
log-likelihood, and BIC model fit.

4. run the script "python discounting_Hyperbolic.py"

5. Check the outputs

6. Copy the data csv files to the folder trial_fits

7. Copy each subjects' k-value to their data csv file so that it
appears exactly the same on each row. This allows the next script
to use the k-value to calculate SV on each line. 

8. run the script "python calculate_sv.py"

9. run the shell script "sh makeEVs.sh"