function Uwn = LowRankContribution(Y,Xk,mode_n,lambda1,p,mu)
% Function used in Algorithm1_3DV2
% Function takes into account the low-rank contributions of an unfolding
    r=30;
    % Compute Classical SVDs in Unfolding
    [~,Sn,~] = ComputeRandomizedSVDUnfoldedxTensor(Xk,mode_n,r); % mode-n

    % Use the Lp-norm function as a surragate for calculating rank
    wn = Derivative_Weighted_Lpnorm_SF(diag(Sn),lambda1,p)./mu;

    % Use Shrinkage Operation on Unfoldings to take into account low-rank
    % properties of the images.
    [Un, Sn, ~] = ComputeRandomizedSVDUnfoldedxTensor(Y,mode_n,r);
    Swn = shrinkage(diag(Sn), wn); 
    ind = find(Swn>0);
    Uwn = Un(:,ind);
end


% function Uwn = LowRankContribution(Y,Xk,mode_n,lambda1,p,mu)
% % Function used in Algorithm1_3DV2
% % Function takes into account the low-rank contributions of an unfolding
%     r=50;
%     % Compute Classical SVDs in Unfolding
%     [~,Sn,~] = ComputeRandomizedSVDUnfoldedxTensor(Xk,mode_n,r); % mode-n
% 
%     % Use the Lp-norm function as a surragate for calculating rank
%     wn = Derivative_Weighted_Lpnorm_SF(diag(Sn),lambda1,p)./mu;
% 
%     % Use Shrinkage Operation on Unfoldings to take into account low-rank
%     % properties of the images.
%     [Un, Sn, ~] = ComputeRandomizedSVDUnfoldedxTensor(Y,mode_n,r);
%     Swn = shrinkage(diag(Sn), wn); 
%     ind = find(Swn>0);
%     Uwn = Un(:,ind);
% end