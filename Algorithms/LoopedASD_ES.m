function [X_fin,Y_fin,k_fin,Res] = LoopedASD_ES(M,Omega,r,tol,kmax)


[m,n] = size(M);
M = sparse(M);
Omega = sparse(Omega);
X = [];
Y = [];
k_fin = 0;
Res = zeros(1,kmax + (r-1)*75);


for i = 1:r-1
    X = [X,rand(m,1)];
    Y = [Y;rand(1,n)];
    [X,Y,k,res_i] = ASD2_ES(M,Omega,X,Y,tol,75);
    Res(k_fin+1:k_fin+k) = res_i;
    k_fin = k_fin+k;
end

X = [X,rand(m,1)];
Y = [Y;rand(1,n)];
[X_fin,Y_fin,k,res_fin] = ASD2_ES(M,Omega,X,Y,tol,kmax);
Res(k_fin+1:k_fin+k) = res_fin;
k_fin = k_fin+k;

end