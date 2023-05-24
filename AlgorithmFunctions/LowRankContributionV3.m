% function X_new = LowRankContributionV3(Y,Xk,lambda1,p,mu)
function X_new = LowRankContributionV3(Y,Xk,lambda1,p,mu)
% Function used in Algorithm1_3D_version3
% Function takes into account the low-rank contributions of an unfolding

    % Compute Classical SVDs in Unfolding to find singular vectors
    [U1,~,~] = ComputeSVDUnfoldedxTensor(Xk,1); % mode-n
    [U2,~,~] = ComputeSVDUnfoldedxTensor(Xk,2);
    [U3,~,~] = ComputeSVDUnfoldedxTensor(Xk,3);

    % Compute Core Tucker Matrix of Xk
    coreX = ConstructCoreTensor(Xk,U1,U2,U3);

    % Use the Lp-norm function as a surragate for calculating rank
    Wn = Derivative_Weighted_Lpnorm_SF(coreX,lambda1,p)./mu; % This is a Tensor

    % Use Shrinkage Operation on Unfoldings to take into account low-rank
    % properties of the images.
    % Compute Classical SVDs in Unfolding to find singular vectors
    [U1,~,~] = ComputeSVDUnfoldedxTensor(Y,1); % mode-n
    [U2,~,~] = ComputeSVDUnfoldedxTensor(Y,2);
    [U3,~,~] = ComputeSVDUnfoldedxTensor(Y,3);

    % Compute Core Tucker Matrix of Y
    coreY = ConstructCoreTensor(Y,U1,U2,U3);
    
    % Shrink the tensor
    Sw = shrinkage(coreY, Wn); 
    % ind = find(Sw>0); % Vector based indices
    % [ind1,ind2,ind3]=ind2sub(size(Sw),ind);
    % Sw = Sw(ind1,ind2,ind3);
    % Uw1 = U1(:,ind1);
    % Uw2 = U2(:,ind2);
    % Uw3 = U3(:,ind3);

    [n,m,r]=size(Sw);
    Sw_vector = reshape(Sw,n*m*r,1);
    ind = find(Sw_vector>0); % indices in Sw_vector that are have values >0
    Sw_vector=Sw_vector(Sw_vector>0); % Reduce Sw_vector to only positive values (singular values)
    % Sw_vector(ind) = 0;
    % Sw = reshape(Sw_vector,n,m,r);

    % Convert vector index to tensor index
    [ind1,ind2,ind3]=ind2sub(size(Sw),ind); 
    
    % Initialize X
    X_new=0;
    for i = 1:length(ind)
        % Check that reshape(kron(v1*v2',v3),n,m,r) creates a rank one
        % tensor from three vectors v1, v2 and v3

        % Add together all the rank one tensors for each singular value in
        % the core matrix
        X_new = X_new + Sw_vector(i)*reshape(kron(U1(:,ind1(i)),U2(:,ind2(i))*U3(:,ind3(i))'),n,m,r);
    end
 % 
 %    % U1(:,ind1)=0;
 %    % U2(:,ind2)=0;
 %    % U3(:,ind3)=0;
 % 
 %    % Invert core to find new X
 %    X_new = ConstructCoreTensor(Sw,U1',U2',U3');
end