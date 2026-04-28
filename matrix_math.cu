#include <iostream>
#include "matrix_math.cuh"

__global__ void sumofmatrix_kernel(float* d_a, float* d_b, float* d_c, int matrixsize) {

    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < matrixsize)
    {
        d_c[i] = d_a[i] + d_b[i];
    }
}


void sumofmatrix(const Matrix& A, const Matrix& B, Matrix& C) {
    int matrixsize = A.row * A.col;

    size_t matrixbytesize = matrixsize * sizeof(float);

    float* d_a, * d_B, * d_c;

    cudaMalloc((void**)&d_a, matrixbytesize);
    cudaMalloc((void**)&d_B, matrixbytesize);
    cudaMalloc((void**)&d_c, matrixbytesize);

    cudaMemcpy(d_a, A.data, matrixbytesize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, B.data, matrixbytesize, cudaMemcpyHostToDevice);

    int blocksize = 256;
    int gridsize = (matrixsize + blocksize - 1) / blocksize;

    sumofmatrix_kernel<<<gridsize, blocksize>>>(d_a,d_B,d_c,matrixsize);
    
    cudaMemcpy(C.data, d_c, matrixbytesize, cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_B);
    cudaFree(d_c);


}


__global__ void difofmatrix_kernel(float* d_a, float* d_b, float* d_c, int matrixsize){
    int i = blockIdx.x * blockDim.x + threadIdx.x;

    if (i < matrixsize)
    {
        d_c[i] = d_a[i] - d_b[i];
    }
    
}

void difofmatrix(const Matrix& A, const Matrix& B, Matrix& C) {
    int matrixsize = A.col * A.row;

    size_t matrixbytesize = matrixsize * sizeof(float);

    float* d_a,* d_b, *d_c;

    cudaMalloc((void**)&d_a, matrixbytesize);
    cudaMalloc((void**)&d_b, matrixbytesize);
    cudaMalloc((void**)&d_c, matrixbytesize);


    cudaMemcpy(d_a, A.data, matrixbytesize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, B.data, matrixbytesize, cudaMemcpyHostToDevice);

    int blocksize = 256;
    int gridsize = (matrixsize + blocksize - 1) / blocksize;

    difofmatrix_kernel<<<gridsize, blocksize>>>(d_a, d_b, d_c, matrixsize);

    cudaMemcpy(C.data, d_c, matrixbytesize, cudaMemcpyDeviceToHost);

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);


}

__global__ void mulofmatrix_samesize_kernel(float* d_a, float* d_b, float* d_c, int widht){

    int row = blockIdx.x * blockDim.x + threadIdx.x;

    int col = blockIdx.y * blockDim.y + threadIdx.y;

    if (row < widht && col < widht)
    {
        float sum = 0.0f;
        
        for (int k = 0; k < widht; k++)
        {
            float a = d_a[row * widht + k];

            float b = d_b[k * widht + col];

            sum += a * b;
        }
        
        d_c[row * widht + col] = sum;

    }
    
}

void mulofmatrix_samesize(const Matrix& A, const Matrix& B, Matrix& C) {

    int widht = A.col;
    int matrixsize = A.col * A.row;

    size_t matrixbytesize = matrixsize * sizeof(float);

    float* d_A, * d_b, *d_c;

    cudaMalloc((void**) &d_A, matrixbytesize);
    cudaMalloc((void**) &d_b, matrixbytesize);
    cudaMalloc((void**) &d_c, matrixbytesize);

    cudaMemcpy(d_A, A.data, matrixbytesize, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, B.data, matrixbytesize, cudaMemcpyHostToDevice);

    dim3 blocksize(16, 16);

    dim3 gridsize((widht + blocksize.x - 1) / blocksize.x,
                  (widht + blocksize.y - 1) / blocksize.y);

    mulofmatrix_samesize_kernel<<<gridsize, blocksize>>>(d_A, d_b, d_c, widht);

    cudaMemcpy(C.data, d_c, matrixbytesize, cudaMemcpyDeviceToHost);

    cudaFree(d_A);
    cudaFree(d_b);
    cudaFree(d_c);

}

__global__ void mulofmatrix_kernel(float* d_a, float* d_b, float* d_c, int a_row, int a_col_b_row, int b_col){
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    int row = blockIdx.y * blockDim.y + threadIdx.y;

    if (row < a_row && col < b_col){
        float sum = 0.0f;
        for (int i = 0; i < a_col_b_row; i++)
        {
            sum += d_a[row * a_col_b_row + i] * d_b[i * b_col + col];
        }
        d_c[row * b_col + col] = sum;       
    }
}


void mulofmatrix(const Matrix& A, const Matrix& B, Matrix& C) {
    int a_row = A.row;
    int a_col_b_row = A.col;
    int b_col = B.col;

    int matrixsize = a_row * b_col;
    int matrixsizea = A.row * A.col;
    int matrixsizeB = B.row * B.col;

    size_t matrixbytesize = sizeof(float) * matrixsize;
    size_t matrixbytesizeA = sizeof(float) * matrixsizea;
    size_t matrixbytesizeB = sizeof(float) * matrixsizeB;
    
    float * d_a, * d_b, * d_c;

    cudaMalloc((void**)&d_a,matrixbytesizeA);
    cudaMalloc((void**)&d_b,matrixbytesizeB);
    cudaMalloc((void**)&d_c,matrixbytesize);

    cudaMemcpy(d_a, A.data, matrixbytesizeA, cudaMemcpyHostToDevice );
    cudaMemcpy(d_b, B.data, matrixbytesizeB, cudaMemcpyHostToDevice );

    dim3 blocksize(16,16,1);

    dim3 gridsize((b_col + blocksize.x - 1) / blocksize.x, 
              (a_row + blocksize.y - 1) / blocksize.y);

    mulofmatrix_kernel<<<gridsize, blocksize>>>(d_a, d_b, d_c, a_row, a_col_b_row, b_col);
    
    
    cudaDeviceSynchronize();

    
    cudaMemcpy(C.data, d_c, matrixbytesize, cudaMemcpyDeviceToHost);


    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

}
