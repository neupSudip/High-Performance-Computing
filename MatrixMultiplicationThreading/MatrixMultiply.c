#include <stdio.h>
#include <stdlib.h>

void main(){
    FILE *fp2 = NULL;
    FILE *fp[5] =  {fopen("SampleMatricesWithErrors.txt","r"),fopen("SampleMatricesWithErrors2.txt","r"),fopen("SampleMatricesWithErrors3.txt","r"),fopen("SampleMatricesWithErrors4.txt","r"),fopen("SampleMatricesWithErrors5.txt","r")
    };
    
    char *output = "matrixresults2050436.txt";
    fp2 = fopen(output, "w");

    int row, col;
    int rows1, cols1, rows2, cols2;
    float matval = 0.0;
    int temp = 0;

    for(int i = 0; i < 5; i++){
        while(!feof(fp[i])){  
            float **matrixA, **matrixB;  
            if (temp == 0 ){
                fscanf(fp[i],"%d,%d",&rows1, &cols1);
                //memory allocation of matrixA
                matrixA = (float **)malloc(rows1 * sizeof(float*)); 
                for (int i = 0; i < rows1; i++) {
	                matrixA[i] = (float*)malloc(cols1 * sizeof(float));
	            }

                for(row = 0; row < rows1; row++){
                    for(col = 0; col < cols1 - 1; col++){
                        fscanf(fp[i],"%f,",&matval);
                        matrixA[row][col] = matval;
                    }
                    fscanf(fp[i],"%f\n",&matval);
                    matrixA[row][col] = matval;
                }
                temp++;
            } else{
                fscanf(fp[i],"%d,%d",&rows2, &cols2);
                //memory allocation of matrixB
                matrixB = (float **)malloc(rows2 * sizeof(float*)); 
                for (int i = 0; i < rows2; i++) {
	                matrixB[i] = (float*)malloc(cols2 * sizeof(float));
	            } 

                for(row = 0; row < rows2; row++){
                    for(col = 0; col < cols2 - 1; col++){
                        fscanf(fp[i],"%f,",&matval);
                        matrixB[row][col] = matval;
                    }
                    fscanf(fp[i],"%f\n",&matval);
                    matrixB[row][col] = matval;
                }  
                temp++; 
            }

            if(temp == 2 ){
                if(cols1 == rows2){ 
                    int p,q,r;
                    float sum = 0;
                    fprintf(fp2, "%d,%d\n",rows1, cols2);

                    for (p = 0; p < rows1; p++) {
                        for (q = 0; q < cols2; q++) {
                            for (r = 0; r < rows2; r++) {
                                sum += matrixA[p][r]*matrixB[r][q];
                            }
                            fprintf(fp2, "%f,",sum);
                            sum = 0;
                        }
                        fprintf(fp2, "\n");   
                    }
                    fprintf(fp2, "\n"); 

                }else{
                    printf("Dimention error row1: %2d column1: %2d row2: %2d column2: %2d\n", rows1, cols1, rows2, rows2);
                }

                for(int i = 0; i < rows1; i++){
                    free(matrixA[i]);
                }
                free(matrixA);
                for(int i = 0; i < rows2; i++){
                    free(matrixB[i]);
                }
                free(matrixB);

                temp = 0;
            } 
        }
        fclose(fp[i]);
    }
  fclose(fp2); 
}
