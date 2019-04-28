
# GPU Implementations

If we are looking for a cheap way to scale out, a GPU implementation could be useful. I must give credit to a member of the teaching staff at QUT (head tutor of HPC) for suggesting to read the file in terms of memory size, rather than line by line. This dramatically reduced the time it takes the program to prepare a chunk of data to send to the GPU.

## Efficiently 1 core per line in the chunk:

* Read in a (rounded) large chunk. "Rounded" because the chunk size will stop randomly - the API will not care if it stops in the middle of a line, so that's up to the programmer.
* Count how many lines there are in the chunk and allocate that many threads to the GPU
* Send the chunk to the GPU
* Within each thread, scroll to the correct line. Each thread has an index, `threadIdx` from `0` to `numThreads - 1`. The thread must scroll past `threadIdx.x` new line symbols to get to the line that it's allocated.

## Text processing:
Unfortunately, the GPU does not have access to `string.h`, or anything similar as far as I can tell. It's intended purely for number crunching. However, since a `char` is basically an `int`, you can do some text processing. The complexity is really up to how much patience you have to do everything manually!