function [XCorruptedTensor,PTensor,XOriginal] = GenerateImageTensor(N,ratio,NeLayers)
% Inputs:
% - N: There are N^2 Pixels in Original Image
% - Ratio: Portion of original image to be removed
% - NeLayers: Number of image layers in tensor
% Outputs:
% - XOriginal: Original image for data (Matrix)
% - XCorruptedTensor: Tensor where each frontal slice is the image once 
%   data has been removed (ratio portion removed).
% - P: Tensor of layers of matrices with 1s at known pixel positions and 0 
%   otherwise.

% Use phantom function to generate an Original Image
XOriginal = phantom(N);

% Initialize Tensors
[n,m] = size(XOriginal);

XCorruptedTensor = zeros(n,m,NeLayers);
PTensor = zeros(n,m,NeLayers);

for i = 1:NeLayers
    % Generate a random permutation of the numbers from 1 and N^2
    ind = randperm(N*N);
    
    % Select portion of Random Permutation of indicies
    ind = ind(1:floor(N*N*ratio)); % Select the first "ratio" of ind
    
    % Remove "ratio" portion of pixels (generated randomly)
    XVector = reshape(XOriginal,N*N,1);
    XVector(ind) = 0;
    XCorruptedTensor(:,:,i) = reshape(XVector,N,N); 

    % P is a Mask that is 1 for all known positions and 0 otherwises
    PVector=ones(N*N,1);
    PVector(ind)=0;
    PTensor(:,:,i) = reshape(PVector,N,N);
end
end