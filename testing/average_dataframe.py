import argparse
import pandas as pd


parser = argparse.ArgumentParser()
parser.add_argument('path_to_user_data')
parser.add_argument('output_path')
args = parser.parse_args()

df = pd.read_csv(args.path_to_user_data)
means = df[[f'ekw{i+1}' for i in range(48)]].mean()
means.to_csv(args.output_path)

