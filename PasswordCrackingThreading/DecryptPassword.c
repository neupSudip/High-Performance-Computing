#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <crypt.h>
#include <unistd.h>
#include <pthread.h>

int count = 0;  
pthread_mutex_t mutex;  

struct threadStruct {
    char start, start2, end, end2;
    char *raw;
};

void substr(char *dest, char *src, int start, int length){
  memcpy(dest, src + start, length);
  *(dest + length) = '\0';
}

void *crack(void *ptr_args){
    struct threadStruct *threadStrt = ptr_args;
    char *salt_and_encrypted = threadStrt->raw;
    char start = threadStrt->start;
    char start2 = threadStrt->start2;
    char end = threadStrt->end;
    char end2 = threadStrt->end2;

    int p, q, r; 
    char salt[7];    
    char plain[5];  
    plain[4] = '\0'; 
    char *encrypt;      

    substr(salt, salt_and_encrypted, 0, 6);

    if (start2 > end2){
        for(p = start; p <= end-1; p++){
            for(q = start2; q <= 'Z'; q++){
                for(r = 0 ; r <= 99; r++){ 
                    sprintf(plain, "%c%c%02d", p , q, r);

                    pthread_mutex_lock(&mutex);
                    encrypt = (char *) crypt(plain, salt);
                    count++;
                    pthread_mutex_unlock(&mutex); 

                    if(strcmp(salt_and_encrypted, encrypt) == 0){
                        printf("************************************\n");
                        printf("Attempt #%d           Text: %s\n", count, plain);
                        printf("************************************\n\n");
                        exit(0);
                    }              
                }
            }
        }
        for(p = end; p <= end; p++){
            for(q = 'A'; q <= end2; q++){
                for(r = 0 ; r <= 99; r++){ 
                    sprintf(plain, "%c%c%02d", p , q, r);

                    pthread_mutex_lock(&mutex);
                    encrypt = (char *) crypt(plain, salt);
                    count++;
                    pthread_mutex_unlock(&mutex);            

                    if(strcmp(salt_and_encrypted, encrypt) == 0){
                        printf("************************************\n");
                        printf("Attempt #%d           Text: %s\n", count, plain);
                        printf("************************************\n\n");
                        exit(0);
                    }   
                }
            }
        }
    }else{
        for(p = start; p <= end; p++){
            for(q = start2; q <= end2; q++){
                for(r = 0 ; r <= 99; r++){ 
                    sprintf(plain, "%c%c%02d", p , q, r);

                    pthread_mutex_lock(&mutex);
                    encrypt = (char *) crypt(plain, salt);
                    count++;
                    pthread_mutex_unlock(&mutex);  

                    if(strcmp(salt_and_encrypted, encrypt) == 0){
                        printf("************************************\n");
                        printf("Attempt #%d           Text: %s\n", count, plain);
                        printf("************************************\n\n");
                        exit(0);
                    }   
                }
            }
        }
    }
}

int main(int argc, char *argv[]){
    int loop;
    char rawPas[92];

    printf("\nEnter encrypted password    : ");
    scanf("%s", rawPas);
    printf("Enter number of thread(<676): ");
    scanf("%d", &loop);
    printf("Please wait while programe decrypt your password.....\n");

    int *slicePart = (int *)malloc(loop*sizeof(int));
    char *sliceStart = (char *)malloc(loop*sizeof(char)); 
    char *sliceStart2 = (char *)malloc(loop*sizeof(char));  
	char *sliceEnd = (char*)malloc(loop*sizeof(char));
	char *sliceEnd2 = (char*)malloc(loop*sizeof(char));

    int remainder = 676 % loop;
    for(int i = 0; i < loop; i++){
		slicePart[i] = 676 / loop;
	}
	for (int i = 0; i < remainder; i++){
	    slicePart[i] += 1;
	}
    int temp = 1;
    int i = 0;
    sliceStart[0] = 'A';
    sliceStart2[0] = 'A';
    for (char a = 'A'; a <= 'Z'; a++){
        for (char b = 'A'; b <= 'Z'; b++){    
            if(slicePart[i] == temp){
                sliceEnd[i] = a;
                sliceEnd2[i] = b;
            }
            if(slicePart[i] == (temp - 1)){
                sliceStart[i+1] = a;
                sliceStart2[i+1] = b;
                temp = 1;
                i++;
            }
            temp++;
        }
    }
    
    struct threadStruct thStruct[loop];
    pthread_t thread[loop];
    pthread_mutex_init(&mutex, NULL);

	for (int i = 0; i < loop; i++){
		thStruct[i].start = sliceStart[i];
        thStruct[i].start2 = sliceStart2[i];
		thStruct[i].end = sliceEnd[i];
        thStruct[i].end2 = sliceEnd2[i];
        thStruct[i].raw = rawPas;
	    pthread_create(&thread[i],NULL,crack,&thStruct[i]);
	}

    for (int i = 0; i < loop; i++){
		pthread_join(thread[i],NULL);
	}

    pthread_mutex_destroy(&mutex);

    free(slicePart);
    free(sliceStart);
	free(sliceEnd);
    free(sliceStart2);
	free(sliceEnd2);
    return 0;
}

