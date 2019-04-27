'''
Python script to average a user's dataframe and compare that to the user's groupby-mean results.
The script will compare the results and will print out the min, max, mean and median deviation 
that the DaskML results have from the manual implementation.

We are expecting a value very close to 0 (if not 0). The window of error is up to you.
'''

import argparse
import pandas as pd
import sys


parser = argparse.ArgumentParser()
parser.add_argument('nmi_uuid')
parser.add_argument('path_to_user_data')
parser.add_argument('path_to_dask_groupby')
parser.add_argument('error_threshold')
args = parser.parse_args()

# calculate user's data based off the groupby results
user_df = pd.read_csv(args.path_to_user_data) 
ground_truth = user_df[[f'ekw{i+1}' for i in range(48)]].mean()

# read user's groupby results from DaskML output
groupby_df = pd.read_csv(args.path_to_dask_groupby)
test_values = groupby_df[groupby_df['nmi_uuid'] == args.nmi_uuid]

diff = ground_truth[[f'ekw{i+1}' for i in range(48)]] - test_values[[f'ekw{i+1}' for i in range(48)]]

# bad exit code if average difference exceeds threshold
if diff.mean().mean() > float(args.error_threshold):
    sys.exit(1)

sys.exit(0)


