function X = xTensor(n,m,r)

X = ones(n,m,r);

for i=1:n
    for j=1:m
        for k=1:r
            X(i,j,k) = X(i,j,k)/(i+j+k);
        end
    end
end
end