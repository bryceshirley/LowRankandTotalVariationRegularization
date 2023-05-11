function [TVnorm,subGradTVnorm] = TotalVariationNormV3(X)
% [TVnorm,subGradTVnorm] = TotalVariationNorm(X) Computes the TV norm of a
% Matrix and the sub gradient matrix of its total variation.
% INPUTS:
% - X is a matrix
% OUTPUTS:
% - TVnorm is the Total Variation norm of X
% - subGradTVnorm is the sub gradient of total variation matrix of X
%
% The total variation of the matrix can be defined as the sum of the 
% absolute differences between neighboring elements along the rows and 
% columns.
% TV(X) = ∑_{i=1}^{m} ∑_{j=1}^{n} (|X[i+1, j] - X[i, j]| + |X[i, j+1] - X[i, j]|)
% Introduce sharp boundary conditions of 0 at indices n+1 and m+1 to
% represent the edge of the image.
    
    %% Output 1: Calculate the TV norm of X
    % find rows and columns of X
    [n,m] = size(X);

    % Set a sharp boundary of 0 as the final column as the image edge
    XRowBoundary = [X,zeros(n,1)]; 
    % Commute the difference between each element its neighbour right
    rowNeighboursDiff = diff(XRowBoundary')'; % MIGHT NEED NEGATING due to subgradients


    % Set a sharp boundary of 0 as the final Row as the image edge
    XColBoundary = [X;zeros(1,m)];
    % Commute the difference between each element its neighbour below
    colNeighboursDiff = diff(XColBoundary); % MIGHT NEED NEGATING due to subgradients

    TVnorm = sum(sum(abs(colNeighboursDiff) + abs(rowNeighboursDiff)));

    %% Output 2: Calculate the Sub-Gradient of the TV norm of X

    % Sub gradient of row neighbour abs difference terms
    rowNeighboursDiff(rowNeighboursDiff<0) = -1;
    rowNeighboursDiff(rowNeighboursDiff>0) = 1;
    % If the difference equals 0 the subgradient can take any value in -1 
    % to 1, hence, we keep 0 for convenience.
    % ALTERNATIVELY WE COULD RANDOMLY GENERATE A NUMBER BETWEEN -1 AND 1.

    % Sub gradient of column neighbour abs difference terms
    colNeighboursDiff(rowNeighboursDiff<0) = -1;
    colNeighboursDiff(rowNeighboursDiff>0) = 1;
    % If the difference equals 0 the subgradient can take any value in -1 
    % to 1, hence, we keep 0 for convenience.
    
    % Combine the matrices to subgradient TV norm matrix
    subGradTVnorm = colNeighboursDiff + rowNeighboursDiff;

end
