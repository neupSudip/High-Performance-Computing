#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <crypt.h>
#include <unistd.h>

#define SALT "$6$AS$"

int main(int argc, char *argv[]){

  if(argc < 2){
		printf("Please provide text (e.g LU99) as an argument. \n");
		exit(1);
	}
  
  printf("%s\n", crypt(argv[1], SALT));

  return 0;
}
