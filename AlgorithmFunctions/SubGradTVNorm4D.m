function subGradTVnorm4D = SubGradTVNorm4D(X)
% Computes the sub gradient Tensor the total variation norm. Applied to a
% 3D ptychography problem.
% INPUTS:
% - X: is a tensor
% OUTPUTS:
% - subGradTVnorm: subgradient tensor of TV norm of tensor X
%
% Formation:
% We don't look at the variation between the ptychography probe dimension 
% as due to the overlap. 
% TV(X) = ∑_{i=1}^{m} ∑_{j=1}^{n} ∑_{k=1}^{r} Tx(i,j,k,l)

    % find rows and columns of X
    [n_energy,n_probe,n_x,n_y] = size(X);

    %% Contributions from Tx(i,j,k,l)

    % X Energy unfolding - Differences taken forward
    X_energy_forward = [reshape(X,n_energy,n_probe*n_x*n_y); ...
        zeros(1,n_probe*n_x*n_y)]; 
    TV_energy_F = -reshape(diff(X_energy_forward,1,1),n_energy, ...
        n_probe,n_x,n_y);

    % % X grid x-direction unfolding - Differences taken forward
    % X_gridx_forward = [reshape(reshape(X,n_energy*n_probe,n_x*n_y)', ...
    %     n_x,n_y*n_energy*n_probe); zeros(1,n_y*n_energy*n_probe)]; 
    % TV_gridx_F = -reshape(diff(X_gridx_forward,1,1),n_energy,n_probe, ...
    %     n_x,n_y);
    % 
    % % X grid y-direction unfolding - Differences taken forward
    % X_gridy_forward = [reshape(X,n_energy*n_probe*n_x,n_y)'; ...
    %     zeros(1,n_energy*n_probe*n_x)]; 
    % TV_gridy_F = -reshape(diff(X_gridy_forward,1,1),n_energy,n_probe, ...
    %     n_x,n_y);
    
     %% Contributions from Tx(i-1,j,k,l), Tx(i,j,k,l-1), Tx(i,j,k,l-1)
    % X Energy unfolding - Differences taken backward
    X_energy_backward = [zeros(1,n_probe*n_x*n_y);reshape(X,n_energy, ...
        n_probe*n_x*n_y)]; 
    TV_energy_B = reshape(diff(X_energy_backward,1,1),n_energy, ...
        n_probe,n_x,n_y); 

    % % X grid x-direction unfolding - Differences taken backward
    % X_gridx_backward = [zeros(1,n_y*n_energy*n_probe); reshape(reshape( ...
    %     X,n_energy*n_probe,n_x*n_y)', n_x,n_y*n_energy*n_probe)]; 
    % TV_gridx_B = reshape(diff(X_gridx_backward,1,1),n_energy,n_probe, ...
    %     n_x,n_y);
    % 
    % % X grid y-direction unfolding - Differences taken backward
    % X_gridy_backward = [zeros(1,n_energy*n_probe*n_x); reshape(X, ...
    %     n_energy*n_probe*n_x,n_y)';]; 
    % TV_gridy_B = reshape(diff(X_gridy_backward,1,1),n_energy,n_probe, ...
    %     n_x,n_y);
    
    
    %% Compute The Subgradient for Each Term and Sum For Subgradient of TV
    subGradTVnorm4D = sign(TV_energy_F) + sign(TV_energy_B); %+ ...
    %                   sign(TV_gridx_F) + sign(TV_gridx_B) + ...
    %                   sign(TV_gridy_F) + sign(TV_gridy_B);

end