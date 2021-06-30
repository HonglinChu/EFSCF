
D = S_xx + T * (mu + lambda3);
Spx_f = sum(conj(model_xf) .* filter_prime_f, 3);
Sgx_f = sum(conj(model_xf) .* gamma_f, 3);

filter_f = ((1/(T*(mu + lambda3)) * bsxfun(@times,  yf{k}, model_xf)) - ((1/(mu + lambda3)) * gamma_f) +(mu/(mu + lambda3)) * filter_prime_f) + (lambda3/(mu + lambda3)) * filter_model_f{k} - ...
    bsxfun(@rdivide,(1/(T*(mu + lambda3)) * bsxfun(@times, model_xf, (S_xx .*  yf{k})) + (lambda3/(mu + lambda3)) * Sfx_pre_f - ...
    (1/(mu + lambda3))* (bsxfun(@times, model_xf, Sgx_f)) +(mu/(mu + lambda3))* (bsxfun(@times, model_xf, Spx_f))), D);

        