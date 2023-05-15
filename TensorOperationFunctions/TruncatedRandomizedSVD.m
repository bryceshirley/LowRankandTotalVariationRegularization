function [Ut,St,Vt]=TruncatedRandomizedSVD(A,tau,r)
    % Find the number of columns in A
    n = size(A,2);
    
    % 1. Generate a Gaussian matrix X in N(0,1)
    X = randn(n,r);
    
    % 2. Compute AX
    AX = A*X;
    
    % 3. Calculate the QR decomposition of AX=QR
    [Q,~] = qr(AX,'econ');
    
    % 4. Find rank-r approximation of the SVD. A \approx QQ'A.
    [U0,S,V] = svd(Q'*A,'econ');
    
    U = Q*U0;
    
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
