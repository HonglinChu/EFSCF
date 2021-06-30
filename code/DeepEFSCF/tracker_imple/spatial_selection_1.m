spatial_selection{k} = max(0,mu - params.lambda2./(numel(pmu)*sqrt(sum(filter_prime.^2,3))));
[~,b] = sort(spatial_selection{k}(:),'descend');
spatial_selection{k}(b(ceil(params.spatial_selection_rate(feature_info.feature_is_deep(k)+1)*numel(b)):end)) = 0;
filter_prime = repmat(spatial_selection{k},1,1,size(filter_prime,3)) .* filter_prime;
