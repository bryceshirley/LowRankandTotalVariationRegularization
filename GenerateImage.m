function GenerateImage()
% Number of pixels N^2
N=500;

% Thickness of stripes (should divide N)
Ns=10; 
% Thickness of strips Ns/2 -1

% Generate test image
originalImage = phantom(N);

% Generate mask of 1s & 0s. When p=1, there is approx (N^2)/2 ones and
% increase p to lower this.
%p=1.5;
%P=((abs(randn(N))-p*abs(randn(N)))>0);

% Gaussian Noise
Pg = randn(N);

% Stripe Mask
% Ps=ones(N);
% for i=1:N
% if mod(i,Ns-1) == 0
% Ps((i-(Ns/2 -1)):i,:) = 0;
% end
% end
reshape(X,1,[])

% Apply Mask function to image
knownPixels = Ps.*Pg.*originalImage;



figure(1);
imshow(Pg.*Ps)
title('Mask')
figure(2);
imshow(originalImage)
title('Original Image')
figure(3);
imshow(knownPixels)
title('Known Pixels')


A=((0:10:95)+5);
B=((0:10:95)+5);
end