all: Encrypt Decrypt

Encrypt: EncryptSHA512.c
	cc -o Encrypt EncryptSHA512.c -lcrypt

Decrypt: DecryptPassword.c
	cc -o Decrypt DecryptPassword.c -lcrypt -pthread

clean:
	rm -f a.out *~ Encrypt Decrypt
