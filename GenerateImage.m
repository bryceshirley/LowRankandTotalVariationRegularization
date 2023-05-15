function [XCorrupted,P,XOriginal] = GenerateImage(imageMatrix,ratio)
% Inputs:
% - imageMatrix: An Image in double matrix form
% - Ratio: Portion of original image to be removed
% Outputs:
% - XOriginal: original Image for data
% - XCorrupted: Image once data has been removed (ratio portion removed)
% - P: Matrix with 1s at known pixel positions and 0 otherwise.

% Use phantom function to generate an Original Image
XOriginal = imageMatrix;

% Dimaension of Image
[n,m]=size(XOriginal);
% Generate a random permutation of the numbers from 1 and N^2
ind = randperm(n*m);

% Select portion of Random Permutation of indicies
ind = ind(1:floor(n*m*ratio)); % Select the first "ratio" of ind

% Remove "ratio" portion of pixels (generated randomly)
XVector = reshape(XOriginal,n*m,1);
XVector(ind) = 0;
XCorrupted = reshape(XVector,n,m); 

% P is a Mask that is 1 for all known positions and 0 otherwises
PVector=ones(n*m,1);
PVector(ind)=0;
P = reshape(PVector,n,m);
end