#include <stdio.h>
#include <stdlib.h>

__device__ char* CudaCrypt(char* text){

	char * prod_password = (char *) malloc(sizeof(char) * 11);
 
	prod_password[0] = text[0] + 2;
	prod_password[1] = text[0] - 2;
	prod_password[2] = text[0] + 1;
	prod_password[3] = text[1] + 3;
	prod_password[4] = text[1] - 3;
	prod_password[5] = text[1] - 1;
	prod_password[6] = text[2] + 2;
	prod_password[7] = text[2] - 2;
	prod_password[8] = text[3] + 4;
	prod_password[9] = text[3] - 4;
	prod_password[10] = '\0';

	for(int i =0; i<10; i++){
		if(i >= 0 && i < 6){ 
			if(prod_password[i] > 90){
				prod_password[i] = (prod_password[i] - 90) + 65;
			}else if(prod_password[i] < 65){
				prod_password[i] = (65 - prod_password[i]) + 65;
			}
		}else{ 
			if(prod_password[i] > 57){
				prod_password[i] = (prod_password[i] - 57) + 48;
			}else if(prod_password[i] < 48){
				prod_password[i] = (48 - prod_password[i]) + 48;
			}
		}
	}
	return prod_password;
}

__global__ void crack(char *text){

    printf("\nText      : %s\nEncrypted : %s\n\n", text, CudaCrypt(text));
}

int main(int argc, char ** argv){

	if(argc < 2){
		printf("Please provide text (e.g AA99) as an argument. \n");
		exit(1);
	}
    char *cpu_text = argv[1];
    char *gpu_text;

    cudaMalloc( (void**) &gpu_text, sizeof(char) * 4); 
    cudaMemcpy(gpu_text, cpu_text, sizeof(char) * 4, cudaMemcpyHostToDevice);

    crack<<< 1, 1>>>(gpu_text);
    cudaThreadSynchronize();

	cudaFree(gpu_text);
    return 0;	
}
