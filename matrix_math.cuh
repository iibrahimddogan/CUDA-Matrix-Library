#ifndef MATRIX_MATH_CUH
#define MATRIX_MATH_CUH

struct Matrix {
    int row;
    int col;
    float* data;
};

void sumofmatrix(const Matrix& A, const Matrix& B, Matrix& C);
void difofmatrix(const Matrix& A, const Matrix& B, Matrix& C);
void mulofmatrix_samesize(const Matrix& A, const Matrix& B, Matrix& C);
void mulofmatrix(const Matrix& A, const Matrix& B, Matrix& C);

#endif 
