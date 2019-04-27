'''
Python script to average a user's dataframe and compare that to the user's groupby-mean results.
The script will compare the results and will print out the min, max, mean and median deviation 
that the DaskML results have from the manual implementation.

We are expecting a value very close to 0 (if not 0). The window of error is up to you.
'''

import argparse
import pandas as pd


#ed8a8330-7dae-4ebe-a5c8-6f9404b9ed97_20190427__1401

parser = argparse.ArgumentParser()
parser.add_argument('nmi_uuid')
parser.add_argument('path_to_user_data')
parser.add_argument('path_to_dask_groupby')
args = parser.parse_args()

# calculate user's data based off the groupby results
user_df = pd.read_csv(args.path_to_user_data) 
ground_truth = user_df[[f'ekw{i+1}' for i in range(48)]].mean()

# read user's groupby results from DaskML output
groupby_df = pd.read_csv(args.path_to_dask_groupby)
test_values = groupby_df[groupby_df['nmi_uuid'] == args.nmi_uuid]

diff = ground_truth[[f'ekw{i+1}' for i in range(48)]] - test_values[[f'ekw{i+1}' for i in range(48)]]

print(
    f'''
        Maximum Difference: {diff.max().max()}
        Minimum Difference: {diff.min().min()}
        Mean Difference: {diff.mean().mean()}
        Median Difference: {diff.median().median()}
    '''
)


