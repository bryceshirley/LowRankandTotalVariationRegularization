function X = FoldTensor(Xn,n,m,r,N)
% Reconstructs Tensor X from the mode-n Unfolds 3D tensor Xn.


% N is the mode-N unfolding
if N == 1
% Frontal Slices (cols are row fibres) mode-1
X = reshape(Xn,n,m,r);

elseif N == 2
% Lateral slices (cols are column fibres) mode-2
X = reshape(reshape(Xn,m*r,n)',n,m,r);

else 
% Horizontal slices (cols are tube fibres) mode 3
X = reshape(Xn',n,m,r);
end