function Uwn = LowRankContribution(Y,Xk,mode_n,lambda1,p,mu)
% Function used in Algorithm1_3DV2
% Function takes into account the low-rank contributions of an unfolding

    % Compute Classical SVDs in Unfolding
    [~,Sn,~] = ComputeSVDUnfoldedxTensor(Xk,mode_n); % mode-n

    % Use the Lp-norm function as a surragate for calculating rank
    wn = Derivative_Weighted_Lpnorm_SF(diag(Sn),lambda1,p)./mu;

    % Use Shrinkage Operation on Unfoldings to take into account low-rank
    % properties of the images.
    [Un, Sn, ~] = ComputeSVDUnfoldedxTensor(Y,mode_n);
    Swn = shrinkage(diag(Sn), wn); 
    ind = find(Swn>0);
    Uwn = Un(:,ind);
end