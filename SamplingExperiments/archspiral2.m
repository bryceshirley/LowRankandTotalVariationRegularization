function archspiral2()
for s=2:50
    r=1;
    theta = s/2;
    coords=zeros(100,2);
    for c=1:100
        coords(c,:) = [r*theta*cos(theta), r*theta*sin(theta)];
        theta = theta + s/(r*sqrt(1 + theta^2));
    end
    plot(coords(:,1),coords(:,2),'*-')
    xlim([-100 100])
    ylim([-100 100])
    pause(0.5)
end
end