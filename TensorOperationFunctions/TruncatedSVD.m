function [Ut,St,Vt]=TruncatedSVD(A,tau)
% Compute the Classical SVD
[U,S,V]=svd(A,'econ');

% Recall that ||A||_fro = ||S||_fro where ||.||_fro is the Frobenius norm defined by the sqrt of the sum of squared elements.
% Vector of singular values
s=diag(S);

% Truncate singular values that satisfy the following condition based on an Error Tolerence of tau
r=sum(cumsum(flip(s).^2) > (tau*norm(s,'fro'))^2);

% Truncate the SVD to from a rank-r approximation.
Ut = U(:,1:r);
St = diag(s(1:r));
Vt = V(:,1:r);
end
