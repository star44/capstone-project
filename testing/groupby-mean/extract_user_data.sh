
# This script is called several times by extract_users_data.sh
# It is intended to be our equivalent of a "groupby" function for testing purposes
# It also calls another script which calculates the mean of each column

if [ $# != 3 ]; then
    echo "Error: You need to run this script with the NMI you wanted and the output folder";
    echo "Example: bash extract_user_data.sh ee53b1c7-fb30-482b-918a-f3c7e734ff6b individual-users-weekends ../../dataset/weekday_split_weekends.csv";
    exit 1;
fi

nmi=$1;
output_folder=$2;
dataset_path=$3;

if [ ! -f $dataset_path ]; then
    echo "Dataset does not exist: $dataset_path";
    exit 1;
fi

[ -d $output_folder ] || mkdir $output_folder;

echo "nmi_uuid,date,ekw1,ekw2,ekw3,ekw4,ekw5,ekw6,ekw7,ekw8,ekw9,ekw10,ekw11,ekw12,ekw13,ekw14,ekw15,ekw16,ekw17,ekw18,ekw19,ekw20,ekw21,ekw22,ekw23,ekw24,ekw25,ekw26,ekw27,ekw28,ekw29,ekw30,ekw31,ekw32,ekw33,ekw34,ekw35,ekw36,ekw37,ekw38,ekw39,ekw40,ekw41,ekw42,ekw43,ekw44,ekw45,ekw46,ekw47,ekw48" >> $output_folder/$nmi.csv;
echo `grep -e $nmi $dataset_path` >> $output_folder/$nmi.csv;

echo "Extraction is complete!";

exit 0;
