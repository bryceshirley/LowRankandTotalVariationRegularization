function X_new = MultilinearSVD(Xk,Uw1,Uw2,Uw3)
% Function used in Algorithm1_3DV2
% Function uses the Multilinear SVD to Reconstuct X_{k+1} from X_{k} 

    % Compute G= X *_1 U1' *_2 U2' *_3 U3'
    G1 = TensorMatrixProduct(Xk,Uw1',1);
    G2 = TensorMatrixProduct(G1,Uw2',2);
    G = TensorMatrixProduct(G2,Uw3',3);

    % Compute Xk+1
    X_new1 = TensorMatrixProduct(G,Uw1,1);
    X_new2 = TensorMatrixProduct(X_new1,Uw2,2);
    X_new = TensorMatrixProduct(X_new2,Uw3,3);
end