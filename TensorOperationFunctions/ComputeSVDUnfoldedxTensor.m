
function [Un,Sn,Vn] = ComputeSVDUnfoldedxTensor(X,n)

% Unfold tensor X into its vertical, frontral and horizontal matrix slice
% forms.
Xn = UnfoldTensor(X,n);

% % Compute the SVD of mode-n unfolded matrix form
[Un,Sn,Vn] = svd(Xn,"econ");
end