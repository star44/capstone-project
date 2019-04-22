
if [ $# != 1 ]; then
    echo "Error: You need to run this script with the NMI you wanted";
    exit 1;
fi

# keep an eye on this line as it'll throw errors if you move your dataset
dataset_path=../../dataset/weekday_split_nmi_data_20181029__weekends.csv
if [ ! -f $dataset_path ]; then
    echo "Dataset does not exist: $dataset_path";
    exit 1;
fi

nmi=$1;
timestamp=`date +%Y%m%d__%H%M`;

[ -d individual-nmi-data ] || mkdir individual-nmi-data;

# By default, grep already takes the exact line that a match is found.
for match in `grep -e $nmi $dataset_path` ; do
    echo $match >> individual-nmi-data/$nmi_$timestamp.csv;
done

