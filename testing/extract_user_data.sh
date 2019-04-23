
# This script is called several times by extract_users_data.sh
# It is intended to be our equivalent of a "groupby" function for testing purposes

if [ $# != 2 ]; then
    echo "Error: You need to run this script with the NMI you wanted and the output folder";
    echo "Example: bash extract_user_data.sh ee53b1c7-fb30-482b-918a-f3c7e734ff6b individual-users-weekends";
    exit 1;
fi

# keep an eye on this line as it'll throw errors if you move your dataset
dataset_path=../../dataset/weekday_split_nmi_data_20181029__weekends.csv
if [ ! -f $dataset_path ]; then
    echo "Dataset does not exist: $dataset_path";
    exit 1;
fi

nmi=$1;
output_folder=$2;
timestamp=`date +%Y%m%d__%H%M`;

[ -d $output_folder ] || mkdir $output_folder;

# By default, grep already takes the exact line that a match is found.
for match in `grep -e $nmi $dataset_path` ; do
    echo $match >> $output_folder/"${nmi}_${timestamp}".csv;
done

