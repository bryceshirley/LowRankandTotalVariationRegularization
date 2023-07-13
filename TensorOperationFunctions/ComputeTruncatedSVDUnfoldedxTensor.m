function [Un,Sn,Vn] = ComputeTruncatedSVDUnfoldedxTensor(X,tau,n)

% Unfold tensor X into its vertical, frontral and horizontal matrix slice
% forms.
Xn = UnfoldTensor(X,n);

% Compute the truncated SVD of mode-n unfolded matrix form
[Un,Sn,Vn] = TruncatedSVD(Xn,tau);
end