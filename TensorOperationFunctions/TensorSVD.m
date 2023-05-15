function Y = TensorSVD(X)
% Computes the Randomized Truncated SVD Approximation of a tensor
% Input:
% - X: 3D Tensor
% Output:
% - Y: Tensor Approximation of X

% Using truncated svd
[Ut1,~,~] = ComputeSVDUnfoldedxTensor(X,1); % mode-1
[Ut2,~,~] = ComputeSVDUnfoldedxTensor(X,2); % mode-2
[Ut3,~,~] = ComputeSVDUnfoldedxTensor(X,3); % mode-3

% Compute G= X *_1 U1' *_2 U2' *_3 U3'
G1 = TensorMatrixProduct(X,Ut1',1);
G2 = TensorMatrixProduct(G1,Ut2',2);
G = TensorMatrixProduct(G2,Ut3',3);

% Compute Y
Y1 = TensorMatrixProduct(G,Ut1,1);
Y2 = TensorMatrixProduct(Y1,Ut2,2);
Y = TensorMatrixProduct(Y2,Ut3,3);

end