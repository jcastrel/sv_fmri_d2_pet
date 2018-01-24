#/usr/bin/env python
import glob
import pandas as pd
import csv

#loop through all files
for filename in glob.iglob('data/*.csv'):
    df = pd.read_csv(filename)
    rename = df.rename(columns ={'rt':'response_time'}, inplace=True)
    rename
    #print(df)
    df.to_csv(filename, sep=',', index=False)

    