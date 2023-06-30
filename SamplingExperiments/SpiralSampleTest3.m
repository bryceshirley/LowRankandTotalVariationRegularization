Rmax=10; % Max radius
Ns = 4; % Number of different spirals
Npoints = 500; % Points in spiral (upper bound for pixel number)

A = 3*pi;
B = 10*pi;
a = (B-A).*rand(Ns,1) + A; % List of random values

for i = 1:Ns
    figure()
    hold on
%% Plot Spiral

k=linspace(0,Rmax^2,Npoints);
xn=sqrt(k).*cos(a(i)*sqrt(k));
yn=sqrt(k).*sin(a(i)*sqrt(k));
plot(xn,yn,'*')
xlim([-10 10])
ylim([-10 10])
title(['a = ',num2str(a(i)/pi)])

%% Plot square

rectangle('Position',[-sqrt(50) -sqrt(50) 2*sqrt(50) 2*sqrt(50)])

%% Plot Circle
%// radius
r = 10;

%// center
c = [0 0];

pos = [c-r 2*r 2*r];
rectangle('Position',pos,'Curvature',[1 1])

%% Plot Line
plot([-sqrt(50) sqrt(50)], [sqrt(50) -sqrt(50)],'b')
plot([-sqrt(50) sqrt(50)], [-sqrt(50) sqrt(50)],'b')
%% Pause
pause(1)
end