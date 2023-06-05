function [U,S,V] = RandomizedSvdABTranspose(A,B,r)
% Function that calculates the SVD of the product of matrices A and B
% transpose.
% Inputs (Matrices):
% - A in Real^(m,n)
% - B in Real^(k,n)
% - r from a rank-r approximation usually r << k 
% Outputs:
% - U orthonormal matrix of left singular vectors (cols)
% - S diagonal matrix of singular values
% - V orthogonal matrix of right singular vectors


    % Find the number of columns in A
    k = size(B,1);

    % 1. Generate a Gaussian matrix X in N(0,1)
    X = randn(k,r);

    % 2. Compute A(B'X)
    ABTransposeX = A*(B'*X);

    % 3. Calculate the QR decomposition of AB'X=QR
    [Qx,~] = qr(ABTransposeX,"econ");
    
    % 4. Find rank-r approximation of the SVD. AB' \approx QQ'AB'.
    [U0,S,V] = svd(Qx'*ABTransposeX,"econ");

    U = Qx*U0;

end