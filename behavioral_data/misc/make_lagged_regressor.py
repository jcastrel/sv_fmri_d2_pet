#/usr/bin/env python
import os
import glob
import pandas as pd
import csv

#read in event files
for filename in glob.iglob('event_files/*_postRT.txt'):
    df = pd.read_csv(filename, header=None, sep="	")
    df.columns = ["onset","duration","pmod"]
    df2 = pd.DataFrame()
#set new onset time to be equal to the current onset time plus reaction time
    df2["onset"] = df["onset"]
#set duration to zero (stick function)
    df2["duration"] = 0
#lag t-0 (current trial) SV pmod    
    df2["pmod"] = df["pmod"]
#lag t-1 (previous trial) SV pmod
    df3 = pd.DataFrame()
    df3["onset"] = df["onset"]
    df3["duration"] = df["duration"]
    df3["pmod"] = df["pmod"].shift(1)
#remove first trial from regressors
#current trial regressors
    df2 = df2.iloc[1:]
#previous trial regressors    
    df3 = df3.iloc[1:]
#save file
    input = filename
    outfile=input.strip('_postRT.txt')
    output = outfile+('_postRT_lagged_SV.txt')
    output2 = outfile+('_postRT_current_SV.txt')
    df2.to_csv(output2, header=None, sep="	",index=0)
    df3.to_csv(output, header=None, sep="	",index=0)
    #print(df2)
    #print(df3)
    os.system('rm event_files/*SV_chosen_postRT_lagged_SV.txt')