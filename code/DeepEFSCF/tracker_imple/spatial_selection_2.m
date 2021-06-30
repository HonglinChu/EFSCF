% spatial_selection{k} = max(0,mu - params.lambda2./(numel(pmu)*sqrt(sum(filter_prime.^2,3))));
% [~,b] = sort(spatial_selection{k}(:),'descend');
% spatial_selection{k}(b(ceil(params.spatial_selection_rate(feature_info.feature_is_deep(k)+1)*numel(b)):end)) = 0;
% filter_prime = repmat(spatial_selection{k},1,1,size(filter_prime,3)) .* filter_prime;

if isfield(seq,'ratio2')
     ratio2=seq.ratio2;
 else
     ratio2=1.4;
end

 if isfield(seq,'lambda2')
    s_lambda2=seq.lambda2;
 else 
    s_lambda2=2.2;
 end
 
 X_temp = pmu;
 
 %solve_h 行稀疏
 L_21=sqrt(sum(sum(X_temp.^2,3),2));%先对通道求和，再对每一行求和
 S_21=max(0,1-s_lambda2./(numel(X_temp)*L_21));%这里enen (1./(mu))
 [~,b]=sort(S_21(:),'descend');   
 S_21(b(ceil(ratio2/params.search_area_scale(feature_info.feature_is_deep(k)+1)*numel(b)):end)) = 0;%前 small_filter_sz

 L21_temp=repmat(S_21,1,size(X_temp,2));% imagesc(L21_temp); surf(L21_temp);
 X_temp=repmat(L21_temp,1,1,size(X_temp,3)).*X_temp;%surf(X_temp(:,:,2));

 %sovle_g 列稀疏
 L_12=sqrt(sum(sum(X_temp.^2,3),1));%先对通道求和，再对每一列求和
 S_12=max(0,1-s_lambda2./(numel(X_temp)*L_12));%surf(L_12);
 [~,b]=sort(S_12(:),'descend');   
 S_12(b(ceil(ratio2/params.search_area_scale(feature_info.feature_is_deep(k)+1)*numel(b)):end)) = 0;%前 small_filter_sz 1.12

 L12_temp=repmat(S_12,size(X_temp,1),1);%imagesc(L12_temp);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
 X_temp=repmat(L12_temp,1,1,size(X_temp,3)).*X_temp;%imagesc(X_temp(:,:,2));

 filter_prime=X_temp;%imagesc(X_temp(:,:,1));
 
