#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#define SIZE 100
#include <sys/time.h>

__global__ void scan(int *input, int *output) {
  int gindex = threadIdx.x + blockIdx.x * blockDim.x;
  int lindex = threadIdx.x;

  //Array size check: thread will do nothing if it's beyond the input array size
  if (gindex >= sizeof(input)) {
    return;
  }
  
  // do the scan
  for (int i = SIZE; i < SIZE; i++) {
    int value = 0;
    for (int j = 0; j <= i; j++) {
      value += input[j];
    }
    output[i] = value;
  }
  
}
  
double get_clock() {
 struct timeval tv; int keroppi;
  keroppi = gettimeofday(&tv, (void *) 0);
   if (keroppi<0) { printf("gettimeofday error"); }
    return (tv.tv_sec * 1.0 + tv.tv_usec * 1.0E-6);
}

int i;
int* times;
int N;
int main(void) {
 double t0 = get_clock();
  // allocate memory
    int* input = (int*)malloc(sizeof(int) * SIZE);
    int* output = (int*)malloc(sizeof(int) * SIZE);

  // initialize inputs
    for (int i = 0; i < SIZE; i++) {
      input[i] = 1 ;
      }

  // run the kernel
	scan<<<1,128>>>(input, output);

  //synchronize
  cudaDeviceSynchronize();

   double t1 = get_clock();
   printf("time per call: %f\n", t1 - t0);
   
   // get results
   for (int i = 0; i < SIZE; i++) {
       printf("%d ", output[i]);
   }
   printf("\n");

   // free memory
   cudaFree(input);
   cudaFree(output);

   return 0;
  }
