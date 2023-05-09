function dg = Derivative_Weighted_Lpnorm_SF(X,lambda,p)
% dg = Derivative_Weighted_Lpnorm_SF(X,lambda,p) computes the derivative of
% the surragate function of the L1-norm as weighted L_p-norm. 
% Note: this is not a norm.
% OUTPUT:
% - dg is the output of the function explained above
% INPUT
% - X is a vector (ie of Matrix Singular Values)
% - lambda is a weighting
% - p is the order of L-norm. p=1 would be the surragate function for the
%   L1-norm

    dg = p.*lambda.*X.^(p-1);
end