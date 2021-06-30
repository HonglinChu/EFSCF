%subproblem f 
%sqrt_d=repmat(sqrt(d),1,output_sz(2));

D=repmat(d,1,output_sz(2));%50x50K^-1
K=repmat(1./d,1,output_sz(2));%50x50K^-1
%B=repmat(b,1,1,model_xf);
%model_xf=bsxfun(@times,sqrt_d,model_xf);

S_xx=sum(conj(model_xf) .* model_xf, 3);
Sf_pre_f = sum(conj(model_xf) .*f_pre_f{k}, 3);%S_xy  这一步的计算在 Multi_channel 有体现
Sfx_pre_f = bsxfun(@times, model_xf, Sf_pre_f); %   ?????
B = S_xx + T *K*(gamma + mu);%gamma初始值=1

Sgx_f = sum(conj(model_xf) .*g_f, 3);
Shx_f = sum(conj(model_xf) .* h_f, 3);

f_f = ((1/(T*(gamma + mu)) * bsxfun(@times,  (D.*yf{k}), model_xf)) - ((1/(gamma + mu)) * h_f) +(gamma/(gamma + mu)) * g_f) + (mu/(gamma + mu)) * f_pre_f{k} - ...
     bsxfun(@rdivide,(1/(T*(gamma + mu)) * bsxfun(@times, model_xf, (S_xx .*  (D.*yf{k}))) + (mu/(gamma + mu)) * Sfx_pre_f - ...
    (1/(gamma + mu))* (bsxfun(@times, model_xf, Shx_f)) +(gamma/(gamma + mu))* (bsxfun(@times, model_xf, Sgx_f))), B);

%update D
C=sum(f_f.*model_xf,3)-yf{k};%对第三通道求和
Err=sqrt(sum(C.*C,2)+eps);   %对每一行求和
d=0.5./Err;
%D =  spdiags(D,0,output_sz(1),output_sz(2));