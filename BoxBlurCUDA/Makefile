CFLAGS = -Wno-deprecated-gpu-targets

all: boxBlurCuda 

boxBlurCuda: BoxBlurCUDA.cu 
	nvcc $(CFLAGS) -o boxBlurCuda BoxBlurCUDA.cu lodepng.cpp

clean:
	rm -f boxBlurCuda *~ a.out
