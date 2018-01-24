#/usr/bin/env python

import glob
import pandas as pd
import csv

#read in event files
#for filename in glob.iglob('event_files/*SV_chosen*.txt'):
for filename in glob.iglob('event_files/*SV_diff*.txt'):
    df = pd.read_csv(filename, header=None, sep="	")
    df.columns = ["onset","duration","pmod"]
    df2 = pd.DataFrame()
#set new onset time to be equal to the current onset time plus reaction time
    df2["onset"] = df["onset"] + df["duration"]
#set duration to zero (stick function)
    df2["duration"] = 0
#leave pmod as is
    df2["pmod"] = df["pmod"]
#save file
    input = filename
    outfile=input.strip('.txt')
    output = outfile+('_postRT.txt')
    df2.to_csv(output, header=None, sep="	",index=0)