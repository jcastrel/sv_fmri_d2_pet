#/usr/bin/env python
#use this script to calculate trialwise subjective values (and related SV decision variables)
#based on hyperbolic function SV = A/(1+(k*D))
#J.Castrellon, Duke University, 12.2017
import glob
import pandas as pd
import csv

#loop through all files
for filename in glob.iglob('trial_fits/*.csv'):
    df = pd.read_csv(filename)
#calculate SV of the smaller-sooner option
    df['SV_SS'] = df['vS'] / (1 + (df['k'] * df['dS']) )
#calculate SV of the larger-later option
    df['SV_LL'] = df['vL'] / (1 + (df['k'] * df['dL']) )
#calculate the sum of the SV for the two options
    df['SV_sum'] = df['SV_SS'] + df['SV_LL']
#calculate the absolute difference between the two options
    df['SV_diff'] = abs(df['SV_LL'] - df['SV_SS'])

#create column for sv chosen and unchosen values
    sv_cho = []   
    for index, row in df.iterrows():
#chose smaller-sooner
        if row['choice'] == 7:
            sv_cho.append(row['SV_SS'])
#chose larger-later
        elif row['choice'] == 8:
            sv_cho.append(row['SV_LL'])
#non response
        elif row['choice']:
            sv_cho.append('')

    df['SV_chosen'] = sv_cho
    
    input = filename
    outfile=input.strip('.csv')
    output = outfile+('_with_SV_parameters.csv')
    df.to_csv(output, sep=',', index=False)
        