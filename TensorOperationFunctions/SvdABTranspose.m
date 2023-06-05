function [U,S,V] = SvdABTranspose(A,B)
% Function that calculates the SVD of the product of matrices A and B
% transpose.
% Inputs (Matrices):
% - A in Real^(m,n)
% - B in Real^(k,n)
% Outputs:
% - U orthonormal matrix of left singular vectors (cols)
% - S diagonal matrix of singular values
% - V orthogonal matrix of right singular vectors

    % Calculate the qr decomposition of A and B
    [Qa, Ra] = qr(A,"econ");
    [Qb, Rb] = qr(B,"econ");
    
    % Define M as the matrix multiplication of rectangular Upper triangular Ra and
    % rectangular lower triangular Rb transpose. This takes far fewer operations than A
    % multiplied by B transpose.
    M = Ra*Rb';

    % Calculate SVD of square matrix M
    [Um,Sm,Vm] = svd(M);

    % Calculate function Ouputs
    U = Qa*Um;
    S = Sm;
    V = Qb*Vm;

end 
