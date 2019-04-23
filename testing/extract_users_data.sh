
# Modify this script and add the NMI's you want to the following variable
# It will call the extract_user_data.sh script.
# Otherwise, you can always call it directly.

if [ $# != 1 ]; then
    echo "Error: you need to give the output folder"
    echo "Example: bash extract_users_data.sh individual-users-weekends"
    exit 1;
fi

output_folder=$1;

nmis=" \
    ee53b1c7-fb30-482b-918a-f3c7e734ff6b \
    ed8a8330-7dae-4ebe-a5c8-6f9404b9ed97 \
";

for nmi in $nmis; do
    bash extract_user_data.sh $nmi $output_folder;
done

