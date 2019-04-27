#!/bin/bash

# This script is meant to test everything to do with the groupby functionality
# to ensure that it's working as intended. This includes data preparation, 
# storage, etc.
# This script is designed to be user-friendly because it's the only script that
# is intended to be called by a user. All other scripts will be called from this script.

# Constants. You may need to change these (or at least double-check them):
weekend_dataset=../../../dataset/weekday_split_weekends.csv
weekday_dataset=../../../dataset/weekday_split_weekdays.csv

weekend_manual_groupby_outputs=individual-users-weekends
weekday_manual_groupby_outputs=individual-users-weekdays

weekend_dask_groupby_outputs=../../../dataset/groupby_results_weekend_groupby_means.csv
weekday_dask_groupby_outputs=../../../dataset/groupby_results_weekdayy_groupby_means.csv

user_subset=../user_subset.txt

error_threshold=0.1;

# Prepare the test data. Run these with caution, they take a while to execute.
bash extract_users_data.sh $weekend_manual_groupby_outputs $weekend_dataset $user_subset;
echo "Data prep is complete for weekends";

# Do not run for weekdays unless you have a garden to tend to, or a mountain to climb
# bash extract_users_data.sh $weekday_manual_groupby_outputs $weekday_dataset $user_subset;
# echo "Data prep is complete for weekdays";

for nmi in `cat $user_subset`; do
    python test_groupby_for_user.py $nmi \
                                    $weekend_manual_groupby_outputs/$nmi.csv \
                                    $weekend_dask_groupby_outputs \
                                    $error_threshold || echo "The groupby data in $nmi does not meet the threshold!";
done;

echo "Test is complete!";

exit 0;




