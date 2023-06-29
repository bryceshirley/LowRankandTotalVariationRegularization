% image size
N = 100;
M = 27;

% Set scale factors (sf)
if M > N
    sf_M = 1;
    sf_N = M/N;
else
    sf_M = N/M;
    sf_N = 1;
end

% Furtherest point from centre of image
Rmax = sqrt((sf_M*M/2)^2 + (sf_N*N/2)^2);

% Density of pixel selection - smaller the smoother the curve
tstep=2*pi/360;


% Parameter to control spiral density
for a = 0.05:0.05:2

% Initialize image
matrix = zeros(N,M);


t=0;
r=0;
while r <= Rmax % When r>Rmax spiral will never re-enter the image.
    
    % Spiral Coordinates
    x=t*cos(a*t)/sf_M;
    y=(t*sin(a*t))/sf_N;

    % Distance from image centre.
    r= sqrt(x^2 + y^2);

        
    % Round to integer
    x_int = round(x+M/2);
    y_int = round(y+N/2);

    % Convert to pixel/Matrix index
    coords = [x_int,y_int];
    try linear_indices = sub2ind([N,M], coords(2), coords(1));
        % Select pixel
        matrix(linear_indices) = 1;
    catch
        % Spiral left image
    end
    
    % Shift to next pixel
    t = t+tstep;
end

figure(1)
imagesc(matrix);
title('Single Pixel Movement')
colorbar;
disp(sum(sum(matrix))/(N*M))
pause(0.5)
end