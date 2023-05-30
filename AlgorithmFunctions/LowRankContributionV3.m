% function X_new = LowRankContributionV3(Y,Xk,lambda1,p,mu)
function X_new = LowRankContributionV3(Y,Xk,lambda1,p,mu)
% Function used in Algorithm1_3D_version3
% Function takes into account the low-rank contributions of an unfolding

    % Compute Classical SVDs in Unfolding to find singular vectors
    [Ux1,~,~] = ComputeSVDUnfoldedxTensor(Xk,1); % mode-n
    [Ux2,~,~] = ComputeSVDUnfoldedxTensor(Xk,2);
    [Ux3,~,~] = ComputeSVDUnfoldedxTensor(Xk,3);

    % Compute Core Tucker Matrix of Xk
    coreX = ConstructCoreTensor(Xk,Ux1,Ux2,Ux3);

    % Use the Lp-norm function as a surragate for calculating rank
    Wn = Derivative_Weighted_Lpnorm_SF(coreX,lambda1,p)./mu; % This is a Tensor

    % Use Shrinkage Operation on Unfoldings to take into account low-rank
    % properties of the images.
    % Compute Classical SVDs in Unfolding to find singular vectors
    [Uy1,~,~] = ComputeSVDUnfoldedxTensor(Y,1); % mode-n
    [Uy2,~,~] = ComputeSVDUnfoldedxTensor(Y,2);
    [Uy3,~,~] = ComputeSVDUnfoldedxTensor(Y,3);

    % Compute Core Tucker Matrix of Y
    coreY = ConstructCoreTensor(Y,Uy1,Uy2,Uy3);
    
    % Shrink the tensor
    Sw = shrinkage(coreY, Wn); 
    [n,m,r]=size(Sw);
    Sw_vector = reshape(Sw,n*m*r,1);
    ind = find(Sw_vector>0); % indices in Sw_vector that are have values >0
    Sw_vector=Sw_vector(ind); % Reduce Sw_vector to only positive values (singular values)

    % Convert vector index to tensor index
    [ind1,ind2,ind3]=ind2sub(size(Sw),ind); 
    
    % Initialize X
    %X_new=0;
    % for i = 1:length(ind)
    %     % Check that reshape(kron(v1*v2',v3),n,m,r) creates a rank one
    %     % tensor from three vectors v1, v2 and v3
    % 
    %     % Add together all the rank one tensors for each singular value in
    %     % the core matrix
    %     X_new = X_new + Sw_vector(i)*reshape(kron(Uy2(:,ind2(i))*Uy3(:,ind3(i))',Uy1(:,ind1(i))),n,m,r);
    % end
    X_new= ConstructCoreTensor(Sw,Uy1',Uy2',Uy3');
end