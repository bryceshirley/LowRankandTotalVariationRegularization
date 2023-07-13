function tk = Computetk(Xk,subGradTVnorm,P,M,lambda2)
% Computes the subgradient of the function defined
% below at X=X_{k}
% F(X) = lambda2 ||X||_{TV} + ||P_{omega}(X-M)||_{Frobenius}
% Lambda2 is a weighting.
% Subgradient of the total variation norm is computed in the the function
% [TVnorm,subGradTVnorm] = TotalVariationNormV2(X).
% The subgradient of the Frobenius norm is the same as the matrix the
% Frobenius norm is operating on.
% INPUTS:
% - Xk: image iteration (Matrix)
% - subGradTVnorm: subgradient of the TV norm of Xk
% - P: is an orthonormal projector such that P(X_{i,j}) is X(i,j) for the
% known pixels (i,j) and zero otherwise.
% - M: Observed image (values we know)


% Subgradient of square of the Frobenius Norm
subGradFROnorm = 2*P.*(Xk-M);

% Compute subgradient of F at Xk
tk = lambda2*subGradTVnorm + subGradFROnorm;
end