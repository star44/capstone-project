#!/bin/bash

# This script is meant to test everything to do with the groupby functionality
# to ensure that it's working as intended. This includes data preparation, 
# storage, etc.
# This script is designed to be user-friendly because it's the only script that
# is intended to be called by a user. All other scripts will be called from this script.

# Constants. You may need to change these (or at least double-check them):
weekend_dataset=../../dataset/weekday_split_weekends.csv
weekday_dataset=../../dataset/weekday_split_weekdays.csv
weekend_manual_groupby_outputs=individual-users-weekends
weekday_manual_groupby_outputs=individual-users-weekdays
user_subset=user_subset.txt

# Prepare the test data. Run these with caution, they take a while to execute.
bash extract_users_data.sh $weekend_manual_groupby_outputs $weekend_dataset $user_subset;
echo "Data prep is complete for weekends";

bash extract_users_data.sh $weekday_manual_groupby_outputs $weekday_dataset $user_subset;
echo "Data prep is complete for weekdays";








