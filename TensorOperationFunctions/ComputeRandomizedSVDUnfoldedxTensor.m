function [Un,Sn,Vn] = ComputeRandomizedSVDUnfoldedxTensor(X,n,r)

% Unfold tensor X into its vertical, frontral and horizontal matrix slice
% forms.
Xn = UnfoldTensor(X,n);

% Compute the randomized SVD of mode-n unfolded matrix form
[Un,Sn,Vn] = randomizedSVD(Xn,r);
end