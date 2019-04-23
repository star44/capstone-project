# This script is meant to test whether a chunk of the dataset has ONLY weekends or weekdays
# It does NOT fully test the splitting of the dataset (such as number of rows, number of columns, format, etc.)

if [ $# != 1 ]; then
    echo "Error: You need to provide the dataset path"
    echo "Example: bash split_dataset.sh ../../dataset/dataset_sample.csv"
    exit 1;
fi

dataset_path=$1;

if [ ! -f $dataset_path ]; then
    echo "File does not exist!";
    exit 1;
fi

# Loop through each date in the dataset (ignore first line)
while read row; do
    calendar_date=`echo $row | grep --only-matching -e '[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}'`;
    day_of_week=`date -jf '%Y-%m-%d' $calendar_date "+%a"`;
    
    if [ $day_of_week = Sat ] || [ $day_of_week = Sun ]; then
        echo $row >> weekend_dataset.csv;
    else
        echo $row >> weekday_dataset.csv;
    fi

done <$dataset_path;

exit 0;


