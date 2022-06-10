#include <stdio.h>
#include <stdlib.h>

__device__ char* CudaCrypt(char* rawPassword){
	char * newPassword = (char *) malloc(sizeof(char) * 11);
 
	newPassword[0] = rawPassword[0] + 2;
	newPassword[1] = rawPassword[0] - 2;
	newPassword[2] = rawPassword[0] + 1;
	newPassword[3] = rawPassword[1] + 3;
	newPassword[4] = rawPassword[1] - 3;
	newPassword[5] = rawPassword[1] - 1;
	newPassword[6] = rawPassword[2] + 2;
	newPassword[7] = rawPassword[2] - 2;
	newPassword[8] = rawPassword[3] + 4;
	newPassword[9] = rawPassword[3] - 4;
	newPassword[10] = '\0';

	for(int i = 0; i < 10; i++){
		if(i >= 0 && i < 6){ 
			if(newPassword[i] > 90){
				newPassword[i] = (newPassword[i] - 90) + 65;
			}else if(newPassword[i] < 65){
				newPassword[i] = (65 - newPassword[i]) + 65;
			}
		}else{ 
			if(newPassword[i] > 57){
				newPassword[i] = (newPassword[i] - 57) + 48;
			}else if(newPassword[i] < 48){
				newPassword[i] = (48 - newPassword[i]) + 48;
			}
		}
	}
	return newPassword;
}

__global__ void crack(char * alphabet, char * numbers, char *text, char *in_hash){
    char genRawPass[4];

    genRawPass[0] = alphabet[blockIdx.x];
    genRawPass[1] = alphabet[blockIdx.y];
    genRawPass[2] = numbers[threadIdx.x];
    genRawPass[3] = numbers[threadIdx.y];

	char *prod_hash = CudaCrypt(genRawPass);

	int counter = 0;
	for(int i = 0; i < 10; i++){
		if (prod_hash[i] == in_hash[i]){
			counter++;
		}
	}

	if(counter == 10){
		for (int j = 0; j < 4; j++){
			text[j] = genRawPass[j];
		}
	}
}

int main(int argc, char **argv){

	if(argc < 2){
		printf("Please provide hash (e.g AAAAAA9999) as an argument. \n");
		exit(1);
	}

	char *cpu_text;
	char *gpu_text;

    char *cpuRawPas = argv[1];
    char *gpuRawPass;

    char cpuAlphabet[26] = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
	char *gpuAlphabet;

    char cpuNumbers[26] = {'0','1','2','3','4','5','6','7','8','9'};
	char *gpuNumbers;

	cpu_text = (char *)malloc(4 * sizeof(char));
	
	cudaMalloc( (void**) &gpu_text, sizeof(char) * 4); 
	cudaMemcpy(gpu_text, cpu_text, sizeof(char) * 4, cudaMemcpyHostToDevice);

	cudaMalloc( (void**) &gpuRawPass, sizeof(char) * 10); 
    cudaMemcpy(gpuRawPass, cpuRawPas, sizeof(char) * 10, cudaMemcpyHostToDevice);

    cudaMalloc( (void**) &gpuAlphabet, sizeof(char) * 26); 
    cudaMemcpy(gpuAlphabet, cpuAlphabet, sizeof(char) * 26, cudaMemcpyHostToDevice);

    cudaMalloc( (void**) &gpuNumbers, sizeof(char) * 10); 
    cudaMemcpy(gpuNumbers, cpuNumbers, sizeof(char) * 10, cudaMemcpyHostToDevice);

    crack<<< dim3(26,26,1), dim3(10,10,1) >>>( gpuAlphabet, gpuNumbers ,gpu_text, gpuRawPass);
    cudaThreadSynchronize();

	cudaMemcpy(cpu_text, gpu_text, sizeof(char) * 4, cudaMemcpyDeviceToHost);

    printf("\nText      : %s\nEncrypted : %s\n\n", cpu_text, cpuRawPas);

	cudaFree(gpu_text);
	cudaFree(gpuRawPass);
	cudaFree(gpuAlphabet);
	cudaFree(gpuNumbers);
    return 0;
}

