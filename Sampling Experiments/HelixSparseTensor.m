function tensor=HelixSparseTensor(N,N_E)
% N_E must be less than or equal to N
t = linspace(0,2*pi,N);
r = N/2;
x= r*cos(t);
y= r*sin(t);
Level = (1:N_E)./N_E+1;
 % Determine the size of the matrix 
x_min = floor(min(x)); 
x_max = ceil(max(x)); 
y_min = floor(min(y)); 
y_max = ceil(max(y)); 
matrix_size = [y_max - y_min + 1, x_max - x_min + 1]; 
% Create the matrix and initialize it with NaN values 
matrix = zeros(matrix_size); 
matrixTopView = zeros(matrix_size);
% Convert X,Y values to linear indices 
x_int = round((x - x_min) + 1); % Convert X values to integers 
y_int = round((y - y_min) + 1); % Convert Y values to integers 
coords = [x_int(:), y_int(:)]; % Combine the X,Y values into a matrix 
linear_indices = sub2ind(matrix_size, coords(:,2), coords(:,1)); % Compute the linear indices 
% Fill in the values at the corresponding indices in the matrix 
tensor = zeros(N+1,N+1,N_E);

for i = 1:N_E
matrix(linear_indices(i)) = Level(i);
matrixTopView(linear_indices(i)) = Level(i);
figure(1)
imagesc(matrix); 
colorbar; 
caxis([0 2]);
axis off
pause(0.1)
tensor(:,:,i)=matrix;
matrix = zeros(matrix_size);
end
close all
addpath ('AlgorithmFunctions\','Algorithms\','TensorOperationFunctions\','Tests\','DataFiles\','DataFunctions\')

figure
imagesc(matrixTopView);
title('Single Pixel Movement')
colorbar; 
axis off

figure
X1 = UnfoldTensor(tensor,1);
imagesc(X1); 
title('Mode-1 unfolding')
colorbar; 
axis off

figure
X2 = UnfoldTensor(tensor,2);
imagesc(X2); 
title('Mode-2 unfolding')
colorbar; 
axis off

figure
X2 = UnfoldTensor(tensor,3);
imagesc(X2); 
title('Mode-3 unfolding')
colorbar; 
axis off
end
