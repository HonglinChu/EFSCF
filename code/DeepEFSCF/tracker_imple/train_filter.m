%% Optimisation of Eqn.12
function [filter_model_f, spatial_selection, channel_selection] = train_filter(xlf, feature_info, yf, seq, params, filter_model_f)

if seq.frame == 1
    filter_model_f = cell(size(xlf));
    channel_selection = cell(size(xlf));
    spatial_selection = params.mask_window;
end

for k = 1 : numel(xlf) 
    
    model_xf = gather(xlf{k});   
     
    % intialize the variables and parameters
    if (seq.frame == 1) %
        filter_model_f{k} = zeros(size(model_xf));
        lambda3 = 1e-3;
        iter_max = 3;
        mu_max = 20;
    else
        lambda3 = params.lambda3(feature_info.feature_is_deep(k)+1);
        iter_max = 2;
        mu_max = 0.1;
    end
 
    filter_f = single(zeros(size(model_xf)));
    filter_prime_f = filter_f;
    gamma_f = filter_f;
    mu  = 1; 
    
    % pre-compute the variables
    
    T = feature_info.data_sz(k)^2;
    S_xx = sum(conj(model_xf) .* model_xf, 3);
    Sfilter_pre_f = sum(conj(model_xf) .* filter_model_f{k}, 3);
    Sfx_pre_f = bsxfun(@times, model_xf, Sfilter_pre_f);
    
    iter = 1;
    
    d=ones(feature_info.data_sz(k),1);
    
    while (iter <= iter_max)
        
       % subproblem Eqn.13.a
       solve_filter_f_1; 
                                                                            

        if iter == iter_max && seq.frame > 1
            break;
        end
        
        % subproblem Eqn.13.b
        % pruning operators are employed to fix the selection ratio
        % <
        pmu = ifft2((mu * filter_f+ gamma_f), 'symmetric');
        
        if (seq.frame == 1)
            filter_prime = zeros(size(pmu));
            channel_selection{k} = ones(size(pmu));
            for i = 1:size(pmu,3)
                filter_prime(:,:,i) = spatial_selection{k} .* pmu(:,:,i);
            end
        else
            filter_prime = pmu;
            if feature_info.feature_is_deep(k)
                channel_selection{k}=[];
                spatial_selection_3;
                spatial_selection{k}=[];
   
            else
                
                spatial_selection_2;
           
                spatial_selection{k}=[];
                channel_selection{k}=[];
               
            end
        end
        filter_prime_f = fft2(filter_prime);
        % >
        
        % subproblem Eqn.13.c
        % <
        gamma_f = gamma_f + (mu * (filter_f - filter_prime_f));
        % >
        
        % update the penalty mu
        % <
        mu = min(1.5 * mu, mu_max);
        % >
        
        iter = iter+1;
    end
    
    % save the trained filters (robustness test)
    %filter_refilter_f{k} = filter_f+randn(size(filter_f))*mean(filter_f(:))*params.stability_factor(feature_info.feature_is_deep(k)+1);
    
    % update the filters Eqn.2
    % <
    if seq.frame == 1
        filter_model_f{k} = filter_f;
    else
        filter_model_f{k} = params.learning_rate(feature_info.feature_is_deep(k)+1)*filter_f ...
            + (1-params.learning_rate(feature_info.feature_is_deep(k)+1))*filter_model_f{k};
    end
    % >
end

end

