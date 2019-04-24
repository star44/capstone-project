/**
 * This file is a C implementation of the dataset split.
 * On the 8GB Google Cloud Instance, it takes 12 minutes to run to completion.
 * This was necessary as the bash implementation in this folder would have taken 5 days on the same machine.
 * 
 * The output is the original dataset split up by weekend and weekday.
 * 
 * For scaling, this implementation can be done by:
 *   - Reading a larger chunk, rather than just line by line
 *   - Using multiple threads to split the chunk by weekends/weekday chunks
 *   - Writing the weekend/weekday chunks to their own files in the main file
*/

#include <cstring>
#include <ctime>
#include <iostream>
#include <thread>

#define NMI_LENGTH 36
#define MAX_NUM_LENGTH 10
#define NUM_NUMERIC_COLS 48
#define DATESTRING_LENGTH 10
#define MAX_LINE_LENGTH 1000

#define MON 1
#define TUE 2
#define WED 3
#define THU 4
#define FRI 5
#define SAT 6
#define SUN 0

const char* dataset = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/qut_it_capstone_ailbatross_20181029_nmi_data_20181029.csv";
const char* weekdays = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/nmi_data_20181029__weekdays.csv";
const char* weekends = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/nmi_data_20181029__weekends.csv";
// TODO: change this following path to the actual groupby file when you make it again
const char* groupbyOutput = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/weekday_split_nmi_data_20181029__weekends.csv"; 



int main(int argc, char* argv[]) {

    FILE* fp = std::fopen(dataset, "r");
    FILE* weekdays_fp = std::fopen(weekdays, "w");
    FILE* weekends_fp = std::fopen(weekends, "w");
    char line[MAX_LINE_LENGTH];
    char date[MAX_LINE_LENGTH];
    struct tm date_parser;

    std::fgets(line, MAX_LINE_LENGTH, fp); // remove first line

    while (!feof(fp)) {
        std::fgets(date, MAX_LINE_LENGTH, fp); // read the line
        std::strcpy(line, date);
        std::strtok(date, ","); // remove nmi

        std::strcpy(date, std::strtok(NULL, ",")); // copy date in
        
        strptime(date, "%Y-%m-%d", &date_parser);
        if (date_parser.tm_wday == SAT || date_parser.tm_wday == SUN) {
            std::fputs(line, weekends_fp);
        }
        else {
            std::fputs(line, weekdays_fp);
        }
    }
    // free all resources 
    std::fclose(fp);
    std::fclose(weekdays_fp);
    std::fclose(weekends_fp);

    return 0;
}