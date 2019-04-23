# This script generates a small sample of a dataset by concatenating the head and the tail of a dataset

if [ $# != 3 ]; then
    echo "Error: You need to give the size of the head, size of the tail, and the path to the dataset you want to use"
    echo "Example: bash generate_small_sample.sh 5000 5000 ../../dataset/weekday_split_nmi_data_20181029__weekends.csv";
    exit 1;
fi

head_size=$1;
tail_size=$2;
dataset_path=$3;
output_file="dataset_sample.csv";

if [ ! -f $dataset_path ]; then
    echo "Dataset does not exist: $dataset_path";
    exit 1;
fi

head -n $head_size $dataset_path > $output_file;
tail -n $tail_size $dataset_path >> $output_file;

