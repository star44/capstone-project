
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <cstdio>
#include <cstring>
#include <ctime>
#include <iostream>
#include <string>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <thread>

#include "file_handling.h"

#define NUM_ROWS 120000000
#define ARRAY_HEIGHT 1000
#define ARRAY_WIDTH 48
#define BLOCK_DIMS 2560
#define GRID_DIMS 256

#define NUM_THREADS 6
#define MATRIX_SIZE (ARRAY_WIDTH * ARRAY_HEIGHT)
#define CHUNK_STRING_SIZE (MAX_LINE_LENGTH * ARRAY_HEIGHT)
#define NUM_CHUNKS (NUM_ROWS / ARRAY_HEIGHT)

const char* PATH_TO_MAX_VALS = "../../max_values_by_user.csv";
const char* PATH_TO_NMI_DATA = "../../nmi_data_20181029.csv";

cudaError_t normalise(char* chunk, char* dev_chunk, float* vals, float* dev_vals, int num_threads);

__global__ void divide(char* dev_chunk, float* dev_vals) {
	int row = threadIdx.x;
	char* ptr = dev_chunk;
	int max;
	
	// scroll the pointer to where it needs to be in the chunk (each thread gets a row from the chunk)
	for (int i = 0; i < row; i++) {
		while (*ptr != '\n') {
			ptr++;
		}
		ptr++; // scroll past the '\n' symbol
	}

	// scroll past first couple columns...
	while (*ptr != ',') {
		ptr++;
	}
	ptr++;
	while (*ptr != ',') {
		ptr++;
	}
	ptr++;
	// read each column into the dev_vals 
	for (int col = 0; col < ARRAY_WIDTH; col++) {
		dev_vals[row * ARRAY_WIDTH + col] = 0.0;
		int factor = 0;
		int decimals = 0;
		while (*ptr != '\n' && *ptr != ',') {
			if (decimals == 0) {
				if (*ptr == '.') {
					factor = -1;
					decimals = 1;
					continue;
				}
				dev_vals[row * ARRAY_WIDTH + col] = dev_vals[row * ARRAY_WIDTH + col] * pow(10.0, factor) + (*ptr - '0');
				factor++;
			}
			else {
				//dev_vals[row * ARRAY_WIDTH + col] = dev_vals[row * ARRAY_WIDTH + col] + (*ptr - '0') * pow(10.0, factor);
				factor--;
			}
			ptr++;
		}
		ptr++;
	}
}


int main() {

	cudaError_t cudaStatus;

	std::FILE* dataset_fp = fopen(PATH_TO_NMI_DATA, "r");
	char* chunk = new char[ARRAY_HEIGHT];
	char* dev_chunk; float* dev_vals;
	char line[MAX_LINE_LENGTH];
	char* token;
	char* lineToken;

	int linesRead = roundedReadChunk(0.95 * ARRAY_HEIGHT, dataset_fp, chunk); // read 900MB into the chunk (plus whatever is needed to get to end of line)
	float* vals = new float[linesRead * ARRAY_WIDTH];
	cudaStatus = cudaMalloc((void**) &dev_chunk, ARRAY_HEIGHT * sizeof(char));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
	}
	cudaStatus = cudaMalloc((void**) &dev_vals, linesRead * ARRAY_WIDTH * sizeof(float));
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMalloc failed!");
	}
	std::fgets(chunk, MAX_LINE_LENGTH, dataset_fp);
	normalise(chunk, dev_chunk, vals, dev_vals, linesRead);
	for (int i = 0; i < linesRead * ARRAY_WIDTH; i++) {
		if (i % ARRAY_WIDTH == 0) {
			std::cout << std::endl;
		}
		std::cout << vals[i] << ", ";
	}

	delete [] chunk; // free host memory
	delete [] vals;
	cudaFree(dev_chunk); // free gpu memory
	cudaFree(dev_vals);

	// cudaDeviceReset must be called before exiting in order for profiling and
	// tracing tools such as Nsight and Visual Profiler to show complete traces.
	cudaStatus = cudaDeviceReset();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceReset failed!");
		return 1;
	}
	return 0;
}


// Helper function for using CUDA to add vectors in parallel.
cudaError_t normalise(char* chunk, char* dev_chunk, float* vals, float* dev_vals, int num_threads) {
	
	cudaError_t cudaStatus;

	// Choose which GPU to run on, change this on a multi-GPU system.
	cudaStatus = cudaSetDevice(0);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaSetDevice failed!  Do you have a CUDA-capable GPU installed?");
	}

	// Copy chunk from host to device
	cudaStatus = cudaMemcpy(dev_chunk, chunk, ARRAY_HEIGHT * sizeof(char), cudaMemcpyHostToDevice);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed when copying from host to device!\n");
	}

	// Launch a kernel on the GPU with one thread for each element.
	divide <<<1, num_threads>>> (dev_chunk, dev_vals);

	std::cout << "Finished computing from GPU" << std::endl;

	// Copy data from device to host
	cudaStatus = cudaMemcpy(vals, dev_vals, num_threads * ARRAY_WIDTH * sizeof(float), cudaMemcpyDeviceToHost);
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaMemcpy failed when copying from device to host!\n");
	}

	// cudaDeviceSynchronize waits for the kernel to finish, and returns
	// any errors encountered during the launch.
	cudaStatus = cudaDeviceSynchronize();
	if (cudaStatus != cudaSuccess) {
		fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
	}
	return cudaStatus;
}