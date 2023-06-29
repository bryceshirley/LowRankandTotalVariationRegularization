function [sample_matrix,sample_image,ratio]=SpiralSampler2(full_image,alpha,Nt,b)
% Function Samples
% Inputs:
% - a: parameter to control spiral density ie portion of image sampled
% - image: image in matrix for
% - tstep: Density of pixel - smaller the smoother the curve
% Outputs:
% - sample_matrix: Matrix with 1s at sampled pixels, 0 otherwise
% - sample_image: Matrix of sampled pixels
% - ratio: ratio of pixels sampled

% Image size
[N,M] = size(full_image);

% Set Spiral Scale Factors (sf) 
if M > N
    sf_M = 1;
    sf_N = M/N;
else
    sf_M = N/M;
    sf_N = 1;
end

% Furtherest point from centre of image
tmax = sqrt((M/2)^2 +(N/2)^2); % Found from Spiral Equation

% Define time-steps
t = linspace(0,tmax,Nt);

% Logarithmic scale for timesteps
% y = a+b(1-exp(kt))
% such that k = (1/a)log(1+(a/b)) where a>0, b>0 and log is the natural log
% This Logarithmic decay equation has an initial value of y=a and decays
% to 0 after t=a time. The parameter b controls the steepness of the
% initial decay gradient with the initial gradient approaching 0 as b
% approaches 0.
a = tmax;
k = (1/a)*log(1+(a/b));
t = flip(a+b.*(1.-exp(k.*t)));

% Initialize sample image
sample_matrix = zeros(N,M);

% Initialize time step t and stopping parameter r.
for i=1:Nt
    
    % Spiral Coordinates
    x=t(i)*cos(alpha*t(i))/sf_M;
    y=t(i)*sin(alpha*t(i))/sf_N;

    % % Distance from image centre.
    % r= sqrt(x^2 + y^2);

        
    % Round to integer
    x_int = round(x+M/2);
    y_int = round(y+N/2);

    % Convert to pixel/Matrix index
    coords = [x_int,y_int];

    try linear_indices = sub2ind([N,M], coords(2), coords(1));
        % Select pixel
        sample_matrix(linear_indices) = 1;
    catch
        % Spiral left image
    end
end

% Function outputs
sample_image=sample_matrix.*full_image;

ratio = sum(sum(sample_matrix))/(N*M);
end