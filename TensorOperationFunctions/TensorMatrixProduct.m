
function Y=TensorMatrixProduct(X,x,n)
% X is a tensor in Real(I1,I2,I3) and x is a matrix in 
% real(J,In) where In is I1, I2 or I3.

% Rows of x
[J,~] = size(x);
    
% Sizes of tensor
[I1,I2,I3] = size(X);

% Use Mode-n unfolding:
Xn = UnfoldTensor(X,n);
    
% Compute the fibres in product Y
Yfibres = x*Xn; 

% Reshape Yfibres into Tensors
if n == 1
    % For mode-1, the product Y in real(J,I2,I3) we have, the columns in 
    % Yfibres are column fibres in the frontal slices:
    Y = reshape(Yfibres,J,I2,I3);
elseif n == 2
    % For mode-2, the product Y in real(I1,J,I3) we have, the columns in 
    % Yfibres are row fibres in the frontal slices:
    Y = reshape(reshape(Yfibres,J*I3,I1)', I1,J,I3);
elseif n == 3
    % For mode-3, the product Y in real(I1,I2,J) we have, the columns in 
    % Yfibres are tube fibres in the horizontal slices:
    Y = reshape(Yfibres',I1,I2,J);
else
    disp('Select an n between 1 and 3')
end

end