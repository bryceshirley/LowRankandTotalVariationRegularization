function mu = GenerateMu(X0,lambda2, P, M)
% This function Generate the proximal parameter by finding the upper bound
% on the Lipchitz constant.
% Inputs:
% - lambda2: weighting on the Total Variation(TV) norm
% - P: is a matrix of 1s in the known true value positions and 0 otherwise
% - M: is a matrix of known true values
% - X0: a matrix in real(m,n)
% Output:
% - mu: the proximal parameter for algorithms.


    % Store constants in structure S for pass variables
    S.lambda = lambda2;
    S.P = P;
    S.M = M;

    % Calculate sub grad of TV norm Lipchithz condition
    [n,m] = size(X0);
    
    
    % Generate Random matrix with same dimensions of X0
    XRand = randn(n,m);

    % Compute Left hand side and right hand side of Lipchitz equation
    [LHS,RHS] = GenerateEquation(X0,XRand,S);

    % Ensure mu>0 and defined 
    while (RHS == 0) || (LHS==0) 
        XRand = randn(n,m);
        [LHS,RHS] = GenerateEquation(X0,XRand,S);
    end
    
    % Compute mu>0 which is greater than the Lipschitz Constant
    mu = LHS/RHS;
end

function subGradFX = ComputeSubGradFunctions(X,S)
% Function that calculates the sub gradient of function f(X) =
% f1(X) + f2(X) where f1(X) = lambd2 *||X||_{TV} and f2(X) = ||P(X-M)||_{FRO}
% Inputs:
% - X: A matrix
% - S: A structure, components defined in main function header comments
% Outputs:
% - subGradFX: the matrix sub gradient of the function f(X)
    
    % Compute Sub Gradient of TV norm of X
    subGradTVnormX = SubGradTVNorm(X);

    % Compute Sub Gradient of Frobenius norm of X
    subGradFROnormX = 2*S.P.*(X-S.M);

    % Compute sub gradient of the function f(X)
    subGradFX = S.lambda*subGradTVnormX+ subGradFROnormX;
end

function [LHS,RHS] = GenerateEquation(X1,X2,S)
% Function that calculates the left and right handside of the Lipschitz
% Equation.
% Inputs:
% - X1: A matrix with in Real(m,n)
% - X2: A matrix with in Real(m,n)
% - S: Structure of constants to be forwarded to nested functions
% Outputs:
% - LHS: Left hand side of Lipschitz Equation
% - RHS: Right hand side of Lipchitz Equation

    subGradFX1 = ComputeSubGradFunctions(X1,S);
    subGradFX2 = ComputeSubGradFunctions(X2,S);

    LHS = norm(subGradFX1 - subGradFX2,'fro');
    
    RHS = norm(X1-X2,'fro');
end