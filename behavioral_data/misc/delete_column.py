#/usr/bin/env python
import glob
import pandas as pd
import csv

#loop through all files
for filename in glob.iglob('*.csv'):
    df = pd.read_csv(filename)
    del df['k']
    df.to_csv(filename, sep=',', index=False)

    