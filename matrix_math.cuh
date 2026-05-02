#ifndef MATRIX_MATH_CUH
#define MATRIX_MATH_CUH

struct CudaMatrix {
    int row;
    int col;
    float* data;
};

void sumofmatrix(const CudaMatrix& A, const CudaMatrix& B, CudaMatrix& C);
void difofmatrix(const CudaMatrix& A, const CudaMatrix& B, CudaMatrix& C);
void mulofmatrix_samesize(const CudaMatrix& A, const CudaMatrix& B, CudaMatrix& C);
void mulofmatrix(const CudaMatrix& A, const CudaMatrix& B, CudaMatrix& C);
void mul_scalar(CudaMatrix& A, float scalar);
void reverse_2x2_matrix(CudaMatrix& A);

#endif 
