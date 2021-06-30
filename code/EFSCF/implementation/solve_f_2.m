%subproblem f 

% if isfield(seq,'ratio3')
%     ratio3=seq.ratio3;
% else 
%     ratio3=9.5;%ratio3=8.5是最好的
% end

ratio3=9.5;

if seq.frame>1
    if isfield(seq,'lambda2')
        mu=seq.lambda2;
    else 
        mu=15;%
    end
end

iter2=1;
while (iter2<=1)
sqrt_d=repmat(sqrt(d),1,output_sz(2)); 
%K=repmat(d,1,output_sz(2));
newmodel_xf=bsxfun(@times,sqrt_d,model_xf);

S_xx=sum(conj(newmodel_xf) .* newmodel_xf, 3);   
Sf_pre_f = sum(conj(newmodel_xf).* f_pre_f{k}, 3);%S_xy  这一步的计算在 Multi_channel 有体现
Sfx_pre_f = bsxfun(@times, newmodel_xf, Sf_pre_f); %   ?????

B = S_xx + T * (gamma + mu);%gamma初始值=1

Sgx_f = sum(conj(newmodel_xf) .* g_f, 3);
Shx_f = sum(conj(newmodel_xf) .* h_f, 3);

%我认为这个公式正确的应该是((gamma/(gamma + mu)) * h_f)  =f_pre_f{k}是上一次的滤波器对应的频域的数值
f_f = ((1/(T*(gamma + mu)) * bsxfun(@times,  sqrt_d.*yf{k}, newmodel_xf)) - ((1/(gamma + mu)) * h_f) +(gamma/(gamma + mu)) * g_f) + (mu/(gamma + mu)) * f_pre_f{k} - ...
     bsxfun(@rdivide,(1/(T*(gamma + mu)) * bsxfun(@times, newmodel_xf, (S_xx .* sqrt_d.*yf{k})) + (mu/(gamma + mu)) * Sfx_pre_f - ...
    (1/(gamma + mu))* (bsxfun(@times, newmodel_xf, Shx_f)) +(gamma/(gamma  + mu))* (bsxfun(@times, newmodel_xf, Sgx_f))), B);


%update D
C=sum(f_f.*model_xf,3)-yf{k};%对第三通道求和
Err=sqrt(sum(C.*C,2)+eps);%对每一行求和
d=ratio3./Err; %发现把这里改大一点或者增加迭代的次数，会好一些
iter2=iter2+1;
end