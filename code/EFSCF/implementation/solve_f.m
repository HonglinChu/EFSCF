
B = S_xx + T * (gamma + mu);%gamma初始值=1 S_xx
Sgx_f = sum(conj(model_xf) .* g_f, 3);
Shx_f = sum(conj(model_xf) .* h_f, 3);
%我认为这个公式正确的应该是((gamma/(gamma + mu)) * h_f)  f_pre_f{k}是上一次的滤波器对应的频域的数值
f_f = ((1/(T*(gamma + mu)) * bsxfun(@times,  yf{k}, model_xf)) - ((1/(gamma + mu)) * h_f) +(gamma/(gamma + mu)) * g_f) + (mu/(gamma + mu)) * f_pre_f{k} - ...
     bsxfun(@rdivide,(1/(T*(gamma + mu)) * bsxfun(@times, model_xf, (S_xx .*  yf{k})) + (mu/(gamma + mu)) * Sfx_pre_f - ...
    (1/(gamma + mu))* (bsxfun(@times, model_xf, Shx_f)) +(gamma/(gamma + mu))* (bsxfun(@times, model_xf, Sgx_f))), B);
% 我认为正确的公式应该是 (gamma/(gamma + mu))* (bsxfun(@times, model_xf, Shx_f))
