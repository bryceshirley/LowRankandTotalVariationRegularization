function [sample_matrix,sample_image,sample_ratio]=SpiralSampler(full_image,approx_sample_ratio)
% Function Samples Images Using A Randomized Constant Velocity Spiral
% Inputs:
% - sample_ratio: the sample ratio
% - full_image: image in matrix for
% Outputs:
% - sample_matrix: Matrix with 1s at sampled pixels, 0 otherwise
% - sample_image: Matrix of sampled pixels
% - sample_ratio: ratio of pixels sampled

% Generate Parameter to Randomly Select Spiral Function
selection_interval = [0.5*pi,10*pi]; % Interval to be tuned
a = (selection_interval(2)-selection_interval(1)).*rand(1,1) + selection_interval(1);

% % Selects approx ratio from user.
% approx_sample_ratio = SampleRatio();

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
Rmax = sqrt((sf_M*M/2)^2 + (sf_N*N/2)^2);

% Select Number of points in Spiral based on Rmax and ratio
spiral_points = round(Rmax*Rmax*pi*approx_sample_ratio);  % this ensures approximately ratio pixels are chosen

% Initialize sample image
sample_matrix = zeros(N,M);

k=linspace(0,Rmax^2,spiral_points);

% Initialize time step t and stopping parameter r.
for i=1:spiral_points
    
    % Spiral Coordinates
    x=sqrt(k(i)).*cos(a*sqrt(k(i)))/sf_M;
    y=sqrt(k(i)).*sin(a*sqrt(k(i)))/sf_N;
   
    % Round to integer
    x_int = round(x+M/2);
    y_int = round(y+N/2);

    % Convert to pixel/Matrix index
    coords = [x_int,y_int];
    try linear_indices = sub2ind([N,M], coords(2), coords(1));
        % Select pixel
        sample_matrix(linear_indices) = 1;
    catch
        % Point outside of image
    end
end

% Function outputs
sample_image=sample_matrix.*full_image;
sample_ratio = sum(sum(sample_matrix))/(N*M);

% imagesc(sample_image)
% pause(.5)
end

% for a = 1:20
% n=1;
% k=1:100;
% xn=sqrt(k*n).*cos(a*sqrt(k*n));
% yn=sqrt(k*n).*sin(a*sqrt(k*n));
% plot(xn,yn,'*')
% pause(0.5);
% end

% Rmax=10; % Max radius
% Ns = 5; % Number of different spirals
% N = Rmax^2; % Points in spiral (upper bound for pixel number)
% for a = linspace(2*pi,5*pi,Ns)
% k=linspace(0,N,N);
% xn=sqrt(k).*cos(a*sqrt(k));
% yn=sqrt(k).*sin(a*sqrt(k));
% figure
% plot(xn,yn,'*')
% xlim([-10 10])
% ylim([-10 10])
% title(['a = ',num2str(a/pi)])
% 
% end

% Rmax=10; % Max radius
% Ns = 100; % Number of different spirals
% Npoints = 500; % Points in spiral (upper bound for pixel number)
% 
% A = 2*pi;
% B = 10*pi;
% a = (B-A).*rand(Ns,1) + A; % List of random values
% 
% for i = 1:Ns
% k=linspace(0,Rmax^2,Npoints);
% xn=sqrt(k).*cos(a(i)*sqrt(k));
% yn=sqrt(k).*sin(a(i)*sqrt(k));
% plot(xn,yn,'*')
% xlim([-10 10])
% ylim([-10 10])
% title(['a = ',num2str(a(i)/pi)])
% pause(0.5)
% end