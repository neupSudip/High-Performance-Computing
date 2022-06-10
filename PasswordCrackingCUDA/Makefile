CFLAGS = -Wno-deprecated-gpu-targets
CC = nvcc

all: Encrypt Decrypt

Encrypt: EncryptPassword.cu 
	$(CC) $(CFLAGS) -o Encrypt EncryptPassword.cu  

Decrypt: DecryptPassword.cu 
	$(CC) $(CFLAGS) -o Decrypt DecryptPassword.cu  

clean:
	rm -f Encrypt Decrypt *~ a.out
