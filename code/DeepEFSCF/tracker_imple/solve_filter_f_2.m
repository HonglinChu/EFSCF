
if isfield(seq,'dd')
    ratio3=seq.dd;
else 
    ratio3=8.5; 
end

iter2=1;
eps=0.00001;
while(iter2<2)
    
   sqrt_d=repmat(sqrt(d),1,feature_info.data_sz(k)); 
   newmodel_xf=bsxfun(@times,sqrt_d,model_xf);
   
   S_xx = sum(conj(newmodel_xf) .* newmodel_xf, 3);
   Sfilter_pre_f = sum(conj(newmodel_xf) .* filter_model_f{k}, 3);
   Sfx_pre_f = bsxfun(@times, newmodel_xf, Sfilter_pre_f);
   
   D = S_xx + T * (mu + lambda3);
   Spx_f = sum(conj(newmodel_xf) .* filter_prime_f, 3);
   Sgx_f = sum(conj(newmodel_xf) .* gamma_f, 3);
   
   filter_f = ((1/(T*(mu + lambda3)) * bsxfun(@times,  sqrt_d.*yf{k}, newmodel_xf)) - ((1/(mu + lambda3)) * gamma_f) +(mu/(mu + lambda3)) * filter_prime_f) + (lambda3/(mu + lambda3)) * filter_model_f{k} - ...
    bsxfun(@rdivide,(1/(T*(mu + lambda3)) * bsxfun(@times, newmodel_xf, (S_xx .* sqrt_d.* yf{k})) + (lambda3/(mu + lambda3)) * Sfx_pre_f - ...
    (1/(mu + lambda3))* (bsxfun(@times, newmodel_xf, Sgx_f)) +(mu/(mu + lambda3))* (bsxfun(@times, newmodel_xf, Spx_f))), D);

   %update D 
   C=sum(filter_f.*model_xf,3)-yf{k};%对第三通道求和
   Err=sqrt(sum(C.*C,2)+eps);%对每一行求和
   d=ratio3./Err;   %发现把这里改大一点或者增加迭代的次数，会好一些
   iter2=iter2+1;
   
end

