# This script is meant to test whether a chunk of the dataset has ONLY weekends or weekdays
# It does NOT fully test the splitting of the dataset (such as number of rows, number of columns, format, etc.)

if [ $# != 2 ]; then
    echo "Error: You need to provide the dataset path and whether you want weekends or weekdays"
    echo "Example: bash test_weekend_weekday_split.sh ../../dataset/dataset_sample.csv weekend"
    exit 1;
fi

dataset_path=$1;
test=$2;

if [ $test != "weekend" ]; then
    if [ $test != "weekday" ]; then
        echo "Error: Your second input must either be \"weekend\" or \"weekday\"";
        exit 1;
    fi
fi


weekends=(Sat Sun);
weekdays=(Mon Tue Wed Thur Fri);

# Loop through each date in the dataset (ignore first line)
for calendar_date in `tail -n +2 $dataset_path | awk -F "\"*,\"*" '{print $2}'`; do
    day_of_week=`date -jf '%Y-%m-%d' $calendar_date "+%a"`;

    # test fails if we are expecting all weekends and we find a weekday
    if [ $test == "weekend" ]; then
        for day in $weekdays; do
            if [ $day_of_week = $day ]; then
                echo "Test failed!";
                exit 1;
            fi
        done
    fi

    # test fails if we are expecting all weekdays and we find a weekend
    if [ $test == "weekday" ]; then
        for day in $weekends; do
            if [ $day_of_week = $day ]; then
                echo "Test failed!";
                exit 1;
            fi
        done
    fi
done

echo "Test passed!";

exit 0;


