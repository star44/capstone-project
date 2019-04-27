
# Modify this script and add the NMI's you want to the following variable
# It will call the extract_user_data.sh script.
# Otherwise, you can always call it directly.

if [ $# != 3 ]; then
    echo "Error: you need to give the output folder"
    echo "Example: bash extract_users_data.sh individual-users-weekends ../../dataset/weekday_split_weekends.csv user_subset.txt"
    exit 1;
fi

output_folder=$1;
dataset_path=$2;
users=$3;

nmis=`cat $users`;

for nmi in $nmis; do
    # extract the user data only if it doesn't exist already
    [ -f $output_folder/$nmi.csv ] || bash extract_user_data.sh $nmi $output_folder $dataset_path;
done

exit 0;

