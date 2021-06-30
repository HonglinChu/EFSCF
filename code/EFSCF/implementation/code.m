function [ F ] = code(X,Y,ite) 
% X: mxn
% Y: cxn
% ite: iteration time
%********************************************%
%        min||X^TF-Y^T||21+beta*||F||2          %
%********************************************%

[m,n]=size(X); %     
[c,~]=size(Y);   %
I=eye(m);             
F=eye(m,c);
D=eye(n,n);

for j=1:ite
    F = inv(X*D*X'+0.01*I)*(X*D*Y');    

    C = X'*F-Y';
    Xi1 = sqrt(sum(C.*C,2)+eps);  
    D = 0.5./Xi1;  
    D = spdiags(D,0,n,n);
end

end

