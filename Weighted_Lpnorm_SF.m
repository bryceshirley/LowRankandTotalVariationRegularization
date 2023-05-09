function g = Weighted_Lpnorm_SF(X,lambda,p)
% g = Weighted_Lpnorm_SF(X,lambda,p) computes the surragate function of the
% weighted L_p-norm
% OUTPUT:
% - g is the output of a function for the surragate function of a weighted 
%   L_p-norm
% INPUT
% - X is a vector (ie of Matrix Singular Values)
% - lambda is a weighting
% - p is the order of L-norm. p=1 would be the surragate function for the
%   L1-norm

    g = lambda.*X.^p;
end