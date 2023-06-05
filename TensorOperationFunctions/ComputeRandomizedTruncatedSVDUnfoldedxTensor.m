function [Un,Sn,Vn] = ComputeRandomizedTruncatedSVDUnfoldedxTensor(X,tau,n,r)

% Unfold tensor X into its vertical, frontral and horizontal matrix slice
% forms.
Xn = UnfoldTensor(X,n);

% Compute the randomized SVD of mode-n unfolded matrix form
[Un,Sn,Vn] = TruncatedRandomizedSVD(Xn,tau,r);
end