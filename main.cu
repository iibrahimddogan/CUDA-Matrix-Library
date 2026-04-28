#include <iostream>
#include "matrix_math.cuh"

int main() {

    int row = 1000;
    int col = 1000;
    int sizeofmatrix = row * col;

    Matrix A = {row, col, new float[sizeofmatrix]};
    Matrix B = {row, col, new float[sizeofmatrix]};
    Matrix C = {row, col, new float[sizeofmatrix]};

    for (int i = 0; i < sizeofmatrix; i++)
    {
        A.data[i] = 1.0f;
        B.data[i] = 2.0f;
    }

    sumofmatrix(A, B, C);
    

    std::cout << "C[0][0] = " << C.data[0] << std::endl;

    difofmatrix(A , B, C);
    
    std::cout << "C[0][0] = " << C.data[0] << std::endl;

    mulofmatrix_samesize(A, B, C);

    std::cout << "C[0][0] = " << C.data[0] << std::endl;
    
    delete[] A.data;
    delete[] B.data;
    delete[] C.data;

    return 0;
    
}

