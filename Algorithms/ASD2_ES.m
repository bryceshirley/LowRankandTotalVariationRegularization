function [X,Y,i,Res] = ASD2_ES(M,Omega,X_0,Y_0,tol,kmax)
%

X_i = X_0;
Y_i = Y_0;
res = M - (X_i*Y_i).*Omega;
res2 = norm(res,'fro')/norm(M,'fro');
Res = ones(1,kmax+1);
Res(1) = res2;
diff = zeros(1,kmax);

for i = 1:kmax
    
    grad_fY = -res * Y_i.';
    update1 = (grad_fY*Y_i).*Omega;
    t_xi = norm(grad_fY,'fro')^2 / norm(update1,'fro')^2;

    X_i = X_i - t_xi*grad_fY;
    res = res + t_xi*update1;

    grad_fX = (-X_i.')*res;
    update2 = (X_i*grad_fX).*Omega;
    t_yi = norm(grad_fX,'fro')^2 / norm(update2,'fro')^2;

    Y_i = Y_i - t_yi*grad_fX;
    res = res + t_yi*update2;
    res2 = norm(res,'fro')/norm(M,'fro');
    
    Res(i+1) = res2;
    diff(i) = abs((log(Res(i+1))-log(Res(i)))/log(10));

    if Res(i+1) < tol
        break
    end
    if i > 51
        if abs(mean(diff(i-50:i))) < 1e-5
            break
        end
    end
end

Res = Res(1:i);
X = X_i;
Y = Y_i;

end
