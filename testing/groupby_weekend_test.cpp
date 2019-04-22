/**
 * The purpose of this test is to make sure that the groupby from DaskML by reproducing it.
 * This test reads from the split dataset. It does _not_ test the splitting of the dataset.
 * 
 * The reason why this test was written in C++ is to minimise inefficient I/O and optimise
 * it to do as little as possible.
*/

#include <cstring>
#include <iostream>
#include <thread>

#define NMI_LENGTH 36
#define MAX_NUM_LENGTH 10
#define NUM_NUMERIC_COLS 48
#define DATESTRING_LENGTH 10
#define MAX_LINE_LENGTH (NMI_LENGTH + DATESTRING_LENGTH + (MAX_NUM_LENGTH + 1) * (NUM_NUMERIC_COLS + 2))

const char* dataset = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/weekday_split_nmi_data_20181029__weekends.csv";
// TODO: change this following path to the actual groupby file when you make it again
const char* groupbyOutput = "/Volumes/ScottsDrive/2019SEM1/IFB399/dataset/weekday_split_nmi_data_20181029__weekends.csv"; 


int roundedReadChunk(char* chunk, int bytesToRead, FILE* fp) {
    std::fread(chunk, bytesToRead, 1, fp);
    int idx = 0;
    while (chunk[bytesToRead + idx - 1] != '\n') {
        idx++;
        chunk[bytesToRead + idx - 1] = std::fgetc(fp);
    }
    return bytesToRead + idx;
}


void parseLineIfUser(char* line, char* user) {
    char lineUser[NMI_LENGTH]; std::strcpy(lineUser, std::strtok(line, ","));
    std::cout << lineUser << std::endl;
    std::cout << user << std::endl;
    // if (std::strcmp(user, lineUser) == 0) {
    //     std::cout << lineUser << std::endl;
    // }
}

void initArray(float* avg) {
    for (int i = 0; i < NUM_NUMERIC_COLS; i++) {
        avg[i] = 0.0;
    }
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cout << "You need to run this script as follows:" << std::endl;
        std::cout << "./groupby_weekend_test CHUNKSIZE NMI_UUID" << std::endl;
        return 1;
    }
    
    int chunkSize = std::atof(argv[1]);
    char user[NMI_LENGTH]; std::strcpy(user, argv[2]);
    float avg[NUM_NUMERIC_COLS]; initArray(avg);
    
    char* chunk = new char[chunkSize];

    FILE* fp = std::fopen(dataset, "r");
    std::fgets(chunk, chunkSize, fp); // remove first line
    
    // read 1000 chunks...
    for (int i = 0; i < 1000; i++) {
        roundedReadChunk(chunk, chunkSize - MAX_LINE_LENGTH, fp);
        char* lineTok = std::strtok(chunk, "\n"); // read line
        while (lineTok != NULL) {
            char* lineUser = std::strtok(NULL, ","); // read user
            if (lineUser != NULL) {
                if (std::strcmp(lineUser, user) == 0) {
                    std::cout << "Found a match!" << std::endl;
                }
            }
            lineTok = std::strtok(NULL, "\n"); // readine
        }
        std::cout << "Iteration: " << i << std::endl;
    }
    delete [] chunk;

    // free all resources 
    std::fclose(fp);

    return 0;
}

