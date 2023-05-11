function Sw = shrinkage(S, w)
% s is a list of singular values and w is the subgradient of a surrogate
% function of the L0 norm.
Sw = S-w;

% Set negative values to 0S
Sw(Sw<0) = 0;
end