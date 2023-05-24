function G = ConstructCoreTensor(Y,U1,U2,U3)
% Function used in Algorithm1_3D_version3
% Function finds the tucker core tensor

    % Compute G= X *_1 U1' *_2 U2' *_3 U3'
    G1 = TensorMatrixProduct(Y,U1',1);
    G2 = TensorMatrixProduct(G1,U2',2);
    G = TensorMatrixProduct(G2,U3',3);
end