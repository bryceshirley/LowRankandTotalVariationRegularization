function Xn = UnfoldTensor(X,N)
% Finds the mode-n Unfolds 3D tensor X.
% if X is a 3,2,2 tensor such that X(:,:,1) = [x1 x2; x3 x4; x5 x6],
% X(:,:,2) = [x7 x9; x10 x11; x12 x13] then vector x is define x=[x1 x2 ...
% x12 x13].
% N is the mode-N unfolding
[n,m,r] = size(X);

%x = reshape(permute(X, [2 1 3]),1,[]);
x = reshape(X,1,[]);
if N == 1
% Frontal Slices (cols are row fibres) mode-1
Xn = reshape(x,n,[]);

elseif N == 2
% Lateral slices (cols are column fibres) mode-1
%Xn = reshape(reshape(x,n,[])',m,[]);
Xn = reshape(reshape(x,n,m*r)',m,r*n);
%reshape(reshape(Xn,m*r,n)', n,m,r)

else 
% Horizontal slices (cols are tube fibres) mode 3
Xn = reshape(x,n*m,[])';
end