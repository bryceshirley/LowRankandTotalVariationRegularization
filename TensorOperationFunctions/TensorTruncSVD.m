function Y = TensorTruncSVD(X,tau)
% Computes the Randomized Truncated SVD Approximation of a tensor
% Input:
% - X: 3D Tensor
% - tau: Tolerence for SVD truncation accuracy
% - r: matrix rank guess for the randomized SVD dimensions
% Output:
% - Y: Tensor Approximation of X

% Using truncated svd
[Ut1,~,~] = ComputeTruncatedSVDUnfoldedxTensor(X,tau,1); % mode-1
[Ut2,~,~] = ComputeTruncatedSVDUnfoldedxTensor(X,tau,2); % mode-2
[Ut3,~,~] = ComputeTruncatedSVDUnfoldedxTensor(X,tau,3); % mode-3

% Compute G
G1 = TensorMatrixProduct(X,Ut1',1);
G2 = TensorMatrixProduct(G1,Ut2',2);
G = TensorMatrixProduct(G2,Ut3',3);

% Compute Y
Y1 = TensorMatrixProduct(G,Ut1,1);
Y2 = TensorMatrixProduct(Y1,Ut2,2);
Y = TensorMatrixProduct(Y2,Ut3,3);

end