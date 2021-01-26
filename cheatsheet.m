%{
% Name: Joshua Vincent
% Lab: BIOE 162
% Session: M | T
% Date: 25 January 2021
%}

% Clear the workspace
clear

% Matrix Notation: A(i,j), where i is the row & j is the column

% Create symbolic variables
syms a11 a12 a13 b11 b21 b31;

% Create a row vector
A = [a11 a12 a13]

% Create a column vector
B = [b11;b21;b31]

% Transpose a row vector into a column vector
AT = A'

% Transplose a column vector into a row vector
BT = B'

% Create symbolic variables for matrices
syms a21 a22 a23 a31 a32 a33 b12 b13 b22 b23 b32 b33

% Matrix Construction
A = [a11 a12 a13;a21 a22 a23;a31 a32 a33]
B = [b11 b12 b13;b21 b22 b23;b31 b32 b33]

% Transpose the matrices
AT = A'
BT = B'

% Matrix Multiplication
matmul = A*B

% Elementwise Multiplication/Hadamard Product
Hadamard = A.*B

% Pull a matrix from the gallery of test matrices in MATLAB
% Pull a Symmetric Positive SemiDefinite Matrix
C = gallery('lehmer', 3)

% Eigen Decomposition
[V, D] = eig(C)

% Prove to yourself that C*D = V*D
