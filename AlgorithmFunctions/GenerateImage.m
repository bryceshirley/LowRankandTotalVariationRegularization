function [XCorrupted,P,XOriginal] = GenerateImage(N,ratio)
% Inputs:
% - N: There are N^2 Pixels in Original Image
% - Ratio: Portion of original image to be removed
% Outputs:
% - XOriginal: original Image for data
% - XCorrupted: Image once data has been removed (ratio portion removed)
% - P: Matrix with 1s at known pixel positions and 0 otherwise.

% Use phantom function to generate an Original Image
XOriginal = phantom(N);

% Generate a random permutation of the numbers from 1 and N^2
ind = randperm(N*N);

% Select portion of Random Permutation of indicies
ind = ind(1:floor(N*N*ratio)); % Select the first "ratio" of ind

% Remove "ratio" portion of pixels (generated randomly)
XVector = reshape(XOriginal,N*N,1);
XVector(ind) = 0;
XCorrupted = reshape(XVector,N,N); 

% P is a Mask that is 1 for all known positions and 0 otherwises
PVector=ones(N*N,1);
PVector(ind)=0;
P = reshape(PVector,N,N);

end