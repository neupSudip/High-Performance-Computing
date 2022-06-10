#include <stdio.h>
#include <stdio.h>
#include <stdlib.h>
#include "lodepng.h"

__global__ void boxBlur(int w, int h, unsigned char *gpu_in, unsigned char *gpu_out){

    int i = blockIdx.x;
    int j = threadIdx.x;

    if(i == 0 && j == 0){
		int a = w * i * 4 + j * 4;
		int b = w * i * 4 + (j + 1) * 4;
		int c = w *(i + 1)*4 + j*4;
		int d = w *(i + 1)*4 + (j + 1)*4;
		gpu_out[a + 0] = (gpu_in[a+0] + gpu_in[b+0] + gpu_in[c+0] + gpu_in[d+0])/4;
		gpu_out[a + 1] = (gpu_in[a+1] + gpu_in[b+1] + gpu_in[c+1] + gpu_in[d+1])/4;
		gpu_out[a + 2] = (gpu_in[a+2] + gpu_in[b+2] + gpu_in[c+2] + gpu_in[d+2])/4;
    }else if(i == 0 && j > 0 && j != (w - 1)){
        int a = w * i * 4 + j * 4;
        int b = w * i * 4 + (j - 1) * 4;
        int c = w * i * 4 + (j + 1) * 4;
        int d = w *(i+1)*4 + (j - 1)*4;
        int e = w *(i+1)*4 + j*4;
        int f = w *(i+1)*4 + (j + 1)*4;
        gpu_out[a + 0] = (gpu_in[b+0] + gpu_in[a+0] + gpu_in[c+0] + gpu_in[d+0] + gpu_in[e+0] + gpu_in[f+0])/6;
        gpu_out[a + 1] = (gpu_in[b + 1]+gpu_in[a + 1]+gpu_in[c + 1]+gpu_in[d + 1]+gpu_in[e + 1]+gpu_in[f + 1])/6;		
        gpu_out[a + 2] = (gpu_in[b + 2]+gpu_in[a + 2]+gpu_in[c + 2]+gpu_in[d + 2]+gpu_in[e + 2]+gpu_in[f + 2])/6;		
	}else if(i == 0 && j == (w-1)){
        int a = w * i * 4 + (j - 1) * 4;
        int b = w * i * 4 + j * 4;
        int c = w *(i + 1)*4 + (j - 1)*4;
        int d = w *(i + 1)*4 + j*4;
        gpu_out[b + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0])/4;
        gpu_out[b + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1])/4;
        gpu_out[b + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2])/4;
    }else if(i > 0 && j == 0 && i != (h-1)){
        int a = w * (i-1) * 4 + j * 4;
        int b = w * (i-1) * 4 + (j+1) * 4;
        int c = w * i * 4 + j * 4;
        int d = w * i * 4 + (j+1) * 4;
        int e = w * (i+1) * 4 + j * 4;
        int f = w * (i+1) * 4 + (j+1) * 4;
        gpu_out[c + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0]+gpu_in[e + 0]+gpu_in[f + 0])/6;
        gpu_out[c + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1]+gpu_in[e + 1]+gpu_in[f + 1])/6;
        gpu_out[c + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2]+gpu_in[e + 2]+gpu_in[f + 2])/6;
    }else if(i > 0 && j == (w-1) && i != (h-1)){
        int a = w * (i-1) * 4 + (j-1) * 4;
        int b = w * (i-1) * 4 + j * 4;
        int c = w * i * 4 + (j-1) * 4;
        int d = w * i * 4 + j * 4;
        int e = w * (i+1) * 4 + (j-1) * 4;
        int f = w * (i+1) * 4 + j * 4;
        gpu_out[d + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0]+gpu_in[e + 0]+gpu_in[f + 0])/6;
        gpu_out[d + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1]+gpu_in[e + 1]+gpu_in[f + 1])/6;
        gpu_out[d + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2]+gpu_in[e + 2]+gpu_in[f + 2])/6;	
    }else if(i > 0 && j == (w-1) && i != (h-1)){
        int a = w * (i-1) * 4 + (j-1) * 4;
        int b = w * (i-1) * 4 + j * 4;
        int c = w * i * 4 + (j-1) * 4;
        int d = w * i * 4 + j * 4;
        int e = w * (i+1) * 4 + (j-1) * 4;
        int f = w * (i+1) * 4 + j * 4;
        gpu_out[d + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0]+gpu_in[e + 0]+gpu_in[f + 0])/6;
        gpu_out[d + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1]+gpu_in[e + 1]+gpu_in[f + 1])/6;
        gpu_out[d + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2]+gpu_in[e + 2]+gpu_in[f + 2])/6;
    }else if(i == (h-1) && j == 0){
        int a = w * (i-1) * 4 + j * 4;
        int b = w * (i-1) * 4 + (j+1) * 4;
        int c = w * i * 4 + j * 4;
        int d = w * i * 4 + (j+1) * 4;
        gpu_out[c + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0])/4;
        gpu_out[c + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1])/4;
        gpu_out[c + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2])/4;	
    }else if(i == (h-1) && j > 0 && j != (w-1)){
        int a = w * (i-1) * 4 + (j-1) * 4;
        int b = w * (i-1) * 4 + j * 4;
        int c = w * (i-1) * 4 + (j+1) * 4;
        int d = w * i * 4 + (j-1) * 4;
        int e = w * i * 4 + j * 4;
        int f = w * i * 4 + (j+1) * 4;
        gpu_out[e + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0]+gpu_in[e + 0]+gpu_in[f + 0])/6;
        gpu_out[e + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1]+gpu_in[e + 1]+gpu_in[f + 1])/6;
        gpu_out[e + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2]+gpu_in[e + 2]+gpu_in[f + 2])/6;
    }else if (i == (h-1) && j == (w - 1)){
        int a = w * (i-1) * 4 + (j-1) * 4;
        int b = w * (i-1) * 4 + j * 4 ;
        int c = w * i * 4 + (j-1) * 4;
        int d = w * i * 4 + j * 4;
        gpu_out[d + 0] = (gpu_in[a + 0]+gpu_in[b + 0]+gpu_in[c + 0]+gpu_in[d + 0])/4;
        gpu_out[d + 1] = (gpu_in[a + 1]+gpu_in[b + 1]+gpu_in[c + 1]+gpu_in[d + 1])/4;
        gpu_out[d + 2] = (gpu_in[a + 2]+gpu_in[b + 2]+gpu_in[c + 2]+gpu_in[d + 2])/4;	
    }else{
        int a = w * (i-1) * 4 + (j-1) * 4;
        int b = w * (i-1) * 4 + j * 4;
        int c = w * (i-1) * 4 + (j+1) * 4;
        int d = w * i * 4 + (j-1) * 4;
        int e = w * i * 4 + j * 4;
        int f = w * i * 4 + (j+1) * 4;
        int g = w * (i+1) * 4 + (j-1) * 4;
        int h = w * (i+1) * 4 + j * 4;
        int k = w * (i+1) * 4 + (j+1) * 4;
        gpu_out[e + 0] = (gpu_in[a+0]+gpu_in[b+0]+gpu_in[c+0]+gpu_in[d+0]+gpu_in[e+0]+gpu_in[f+0]+gpu_in[g+0]+gpu_in[h+0]+gpu_in[k+0])/9;
        gpu_out[e+1] = (gpu_in[a+1]+gpu_in[b+1]+gpu_in[c+1]+gpu_in[d+1]+gpu_in[e+1]+gpu_in[f+1]+gpu_in[g+1]+gpu_in[h+1]+gpu_in[k+1])/9;
        gpu_out[e+2] = (gpu_in[a+2]+gpu_in[b+2]+gpu_in[c+2]+gpu_in[d+2]+gpu_in[e+2]+gpu_in[f+2]+gpu_in[g+2]+gpu_in[h+2]+gpu_in[k+2])/9;
	}	
	gpu_out[w * i * 4 + j * 4 + 3] = gpu_in[w * i * 4 + j * 4 + 3];	

}

int main(int argc, char **argv){
    if(argc < 2){
		printf("Please provide png image as an argument. \n");
		exit(1);
	}

    unsigned int error;
    unsigned int encError;
    unsigned char *image;
    unsigned int width;
    unsigned int height;
    char *filename = argv[1];
    const char *newImage = "bluredImage.png";

    error = lodepng_decode32_file(&image, &width, &height, filename);
    if(error){
        printf("Decoding error %u: %s\n", error, lodepng_error_text(error));
        exit(1);
    }

    const int ARRAY_SIZE = width * height * 4;
    const int ARRAY_BYTES = ARRAY_SIZE * sizeof(unsigned char);
    unsigned char cpu_in[ARRAY_SIZE];
    unsigned char cpu_out[ARRAY_SIZE];

    for (int i = 0; i < ARRAY_SIZE; i++) {
        cpu_in[i] = image[i];
    }

    unsigned char *gpu_in;
    unsigned char *gpu_out;
    cudaMalloc((void**) &gpu_in, ARRAY_BYTES);
    cudaMalloc((void**) &gpu_out, ARRAY_BYTES);

    cudaMemcpy(gpu_in, cpu_in, ARRAY_BYTES, cudaMemcpyHostToDevice);
    boxBlur<<< height, width >>>(width, height, gpu_in, gpu_out);
    cudaMemcpy(cpu_out, gpu_out, ARRAY_BYTES, cudaMemcpyDeviceToHost);

    encError = lodepng_encode32_file(newImage, cpu_out, width, height);
    if(encError){
        printf("Encoding error %u: %s\n", error, lodepng_error_text(encError));
        exit(1);
    } else{
        printf("\nOutput file name : %s \n\n", newImage);
    }

    free(image);
    cudaFree(gpu_in);
    cudaFree(gpu_out);
    return 0;
}
