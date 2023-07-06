Rmax=10; % Max radius
Ns = 11; % Number of different spirals
Npoints = 100; % Points in spiral (upper bound for pixel number)


A = 0;
B = 5*pi;
% a = (B-A).*rand(Ns,1) + A; % List of random values
a = linspace(A,B,Ns);

for i = 2:Ns
%% Plot Spirals
figure()
%Points
k=linspace(0,Rmax^2,Npoints);
xn=sqrt(k).*cos(a(i)*sqrt(k));
yn=sqrt(k).*sin(a(i)*sqrt(k));
plot(xn,yn,'k*')
    hold on

% Smooth Spiral
curvePoints =linspace(0,Rmax^2,100000);
x=sqrt(curvePoints).*cos(a(i)*sqrt(curvePoints));
y=sqrt(curvePoints).*sin(a(i)*sqrt(curvePoints));
plot(x,y,'r-')

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

% Plot Line
plot([-sqrt(50) sqrt(50)], [sqrt(50) -sqrt(50)],'k')
plot([-sqrt(50) sqrt(50)], [-sqrt(50) sqrt(50)],'k')
% %% Pause
% pause(1)
% hold off
end