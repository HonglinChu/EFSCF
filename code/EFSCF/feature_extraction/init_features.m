function [features, gparams, feature_info] = init_features(features, gparams, is_color_image, img_sample_sz, size_mode)

if nargin < 3
    size_mode = 'same';
end
% 设置gparams参数的缺省值，这部分大家不用管
% Set missing global parameters to default values
if ~isfield(gparams, 'normalize_power')
    gparams.normalize_power = [];
end
if ~isfield(gparams, 'normalize_size')
    gparams.normalize_size = true;
end
if ~isfield(gparams, 'normalize_dim')
    gparams.normalize_dim = false;
end
if ~isfield(gparams, 'square_root_normalization')
    gparams.square_root_normalization = false;
end
if ~isfield(gparams, 'use_gpu')
    gparams.use_gpu = false;
end
%我们一般都是用彩色图像，所以这里不必太在意
% find which features to keep   length(features)=3
feat_ind = false(length(features),1);%创建大小为3x1的逻辑矩阵，每一个元素都是逻辑值0
for n = 1:length(features)%循环遍历三种特征提取方法
    
    if ~isfield(features{n}.fparams,'useForColor')
        features{n}.fparams.useForColor = true;
    end
    
    if ~isfield(features{n}.fparams,'useForGray')
        features{n}.fparams.useForGray = true;
    end
    %使用color，并且是彩色图像
    if (features{n}.fparams.useForColor && is_color_image) || (features{n}.fparams.useForGray && ~is_color_image)
        % keep feature
        feat_ind(n) = true;
    end
end

% remove features that are not used
features = features(feat_ind);%如果某一个特征不使用，则去除对应的特征提取函数

num_features = length(features);%获取cell的成员数量

feature_info.min_cell_size = zeros(num_features,1);%找到最小的cellsize

%----------------------------循环提取不同的特征开始--------------------------------------------%
% Initialize features by
% - setting the dimension (nDim)
% - specifying if a cell array is returned (is_cell)
% - setting default values of missing feature-specific parameters
% - loading and initializing necessary data (e.g. the lookup table or the network)
for k = 1:length(features)%len=3
    if isequal(features{k}.getFeature, @get_fhog)% 1 判断函数两个函数句柄是否相等，如果是hog提取函数
        if ~isfield(features{k}.fparams, 'nOrients')%没有指定则添加方向bins
            features{k}.fparams.nOrients = 9;%方向=9
        end%
        features{k}.fparams.nDim = 3*features{k}.fparams.nOrients+5-1;%31维度的特征，具体可以参考fhog的提取
        features{k}.is_cell = false;%非hog特征？？？？？
        features{k}.is_cnn = false;%非深度特征
        
    elseif isequal(features{k}.getFeature, @get_table_feature)%2 获取CN特征
        table = load(['lookup_tables/' features{k}.fparams.tablename]);%features{k}.fparams.tablename='CNnorm'
        features{k}.fparams.nDim = size(table.(features{k}.fparams.tablename),2);%维度是10个通道
        features{k}.is_cell = false;
        features{k}.is_cnn = false;
        
    elseif isequal(features{k}.getFeature, @get_colorspace)%3 获取灰度特征
        features{k}.fparams.nDim = 1;%灰度特征只有一个通道
        features{k}.is_cell = false;
        features{k}.is_cnn = false;
    %4 这里的深度特征暂时不去考虑  
    elseif isequal(features{k}.getFeature, @get_cnn_layers) || isequal(features{k}.getFeature, @get_OFcnn_layers)
        % make sure the layers are correcly sorted
        features{k}.fparams.output_layer = sort(features{k}.fparams.output_layer);
        
        % Set default parameters
        if ~isfield(features{k}.fparams, 'input_size_mode')
            features{k}.fparams.input_size_mode = 'adaptive';
        end
        if ~isfield(features{k}.fparams, 'input_size_scale')
            features{k}.fparams.input_size_scale = 1;
        end
        if ~isfield(features{k}.fparams, 'downsample_factor')
            features{k}.fparams.downsample_factor = ones(1, length(features{k}.fparams.output_layer));
        end
        
        % load the network
        net = load_cnn(features{k}.fparams, img_sample_sz);
        
        % find the dimensionality of each layer
        features{k}.fparams.nDim = net.info.dataSize(3, features{k}.fparams.output_layer+1)';
        
        % find the stride of the layers
        if isfield(net.info, 'receptiveFieldStride')
            net_info_stride = cat(2, [1; 1], net.info.receptiveFieldStride);
        else
            net_info_stride = [1; 1];
        end
        
        % compute the cell size of the layers (takes down-sampling factor
        % into account)
        features{k}.fparams.cell_size = net_info_stride(1, features{k}.fparams.output_layer+1)' .* features{k}.fparams.downsample_factor';
        
        % this feature will always return a cell array
        features{k}.is_cell = true;
        features{k}.is_cnn = true;
    elseif isequal(features{k}.getFeature,@get_eitel_cnn)%这个而是什么深度特征？？？？
        features{k}.fparams = make_eitel_feature(features{k}.fparams);
    else
        error('Unknown feature type');
    end

    % Set default cell size
    if ~isfield(features{k}.fparams, 'cell_size')% cell_size 如果不存在进行设置，实际上已经设置好了cell_size=4
        features{k}.fparams.cell_size = 1;
    end
    
    % Set default penalty
    if ~isfield(features{k}.fparams, 'penalty')%并没有设置好，所以这重新进行设置
        features{k}.fparams.penalty = zeros(length(features{k}.fparams.nDim),1);%每一个通道的惩罚项初始都是0
    end
    
    % Find the minimum cell size of each layer
    feature_info.min_cell_size(k) = min(features{k}.fparams.cell_size);%三种特征的cell的大小都是4 
end
%------------------------------------------------------------------------%
% Order the features in increasing minimal cell size
[~, feat_ind] = sort(feature_info.min_cell_size);%
features = features(feat_ind);
feature_info.min_cell_size = feature_info.min_cell_size(feat_ind);
%以上三步的操作属于多余
% Set feature info
feature_info.dim_block = cell(num_features,1);%三种特征
feature_info.penalty_block = cell(num_features,1);%每种特征对应的惩罚项

for k = 1:length(features)
    % update feature info
    feature_info.dim_block{k} = features{k}.fparams.nDim;%
    feature_info.penalty_block{k} = features{k}.fparams.penalty(:);%每种特征对应的惩罚项=0
end
% Feature info for each cell block  Convert the contents of a cell array into a single matrix
feature_info.dim = cell2mat(feature_info.dim_block);%feature_info.dim_block={[1]};{[31]};{[10]}
feature_info.penalty = cell2mat(feature_info.penalty_block);

% Find if there is any CNN feature 关于cnn特征这里可以跳过，因为速度真的是太慢了，我们可以不进行比较
cnn_feature_ind = -1;
for k = 1:length(features)
    if features{k}.is_cnn
        cnn_feature_ind = k;
    end
end

% This ugly code sets the image sample size to be used for extracting the
% features. It then computes the data size (size of the features) and the
% image support size (the corresponding size in the image).
if cnn_feature_ind > 0
    scale = features{cnn_feature_ind}.fparams.input_size_scale;
    
    new_img_sample_sz = img_sample_sz;
    
    % First try decrease one
    net_info = net.info;
    
    if ~strcmpi(size_mode, 'same') && strcmpi(features{cnn_feature_ind}.fparams.input_size_mode, 'adaptive')
        orig_sz = net.info.dataSize(1:2,end)' / features{cnn_feature_ind}.fparams.downsample_factor(end);
        
        if strcmpi(size_mode, 'exact')
            desired_sz = orig_sz + 1;
        elseif strcmpi(size_mode, 'odd_cells')
            desired_sz = orig_sz + 1 + mod(orig_sz,2);
        end
        
        while desired_sz(1) > net_info.dataSize(1,end)
            new_img_sample_sz = new_img_sample_sz + [1, 0];
            net_info = vl_simplenn_display(net, 'inputSize', [round(scale * new_img_sample_sz), 3 1]);
        end
        while desired_sz(2) > net_info.dataSize(2,end)
            new_img_sample_sz = new_img_sample_sz + [0, 1];
            net_info = vl_simplenn_display(net, 'inputSize', [round(scale * new_img_sample_sz), 3 1]);
        end
    end
    
    feature_info.img_sample_sz = round(new_img_sample_sz);
    
    if strcmpi(features{cnn_feature_ind}.fparams.input_size_mode, 'adaptive')
        features{cnn_feature_ind}.img_input_sz = feature_info.img_sample_sz;
    else
        features{cnn_feature_ind}.img_input_sz = net.meta.normalization.imageSize(1:2);
    end
    
    % Sample size to be input to the net
    scaled_sample_sz = round(scale * features{cnn_feature_ind}.img_input_sz);
    
    if isfield(net_info, 'receptiveFieldStride')
        net_info_stride = cat(2, [1; 1], net_info.receptiveFieldStride);
    else
        net_info_stride = [1; 1];
    end
    
    net_stride = net_info_stride(:, features{cnn_feature_ind}.fparams.output_layer+1)';
    total_feat_sz = net_info.dataSize(1:2, features{cnn_feature_ind}.fparams.output_layer+1)';
    
    shrink_number = max(2 * ceil((net_stride(end,:) .* total_feat_sz(end,:) - scaled_sample_sz) ./ (2 * net_stride(end,:))), 0);
    
    deepest_layer_sz = total_feat_sz(end,:) - shrink_number;
    scaled_support_sz = net_stride(end,:) .* deepest_layer_sz;
    
    % Calculate output size for each layer
    cnn_output_sz = round(bsxfun(@rdivide, scaled_support_sz, net_stride));
    features{cnn_feature_ind}.fparams.start_ind = floor((total_feat_sz - cnn_output_sz)/2) + 1;
    features{cnn_feature_ind}.fparams.end_ind = features{cnn_feature_ind}.fparams.start_ind + cnn_output_sz - 1;
    
    feature_info.img_support_sz = round(scaled_support_sz .* feature_info.img_sample_sz ./ scaled_sample_sz);
    
    % Set the input size
    features{cnn_feature_ind}.fparams.net = set_cnn_input_size(net, feature_info.img_sample_sz);
    
    if gparams.use_gpu
        if isempty(gparams.gpu_id)
            gpuDevice();
        elseif gparams.gpu_id > 0
            gpuDevice(gparams.gpu_id);
        end
        features{cnn_feature_ind}.fparams.net = vl_simplenn_move(features{cnn_feature_ind}.fparams.net, 'gpu');
    end
else
    max_cell_size = max(feature_info.min_cell_size);
    
    if strcmpi(size_mode, 'same')
        feature_info.img_sample_sz = round(img_sample_sz);
    elseif strcmpi(size_mode, 'exact')%默认使用的是exact 这里因为hog_cell=4  所以要四舍五入取整数
        feature_info.img_sample_sz = round(img_sample_sz / max_cell_size) * max_cell_size;
    elseif strcmpi(size_mode, 'odd_cells')
        new_img_sample_sz = (1 + 2*round(img_sample_sz / (2*max_cell_size))) * max_cell_size;
        
        % Check the size with the largest number of odd dimensions (choices in the
        % third dimension)
        feature_sz_choices = floor(bsxfun(@rdivide, bsxfun(@plus, new_img_sample_sz, reshape(0:max_cell_size-1, 1, 1, [])), feature_info.min_cell_size));
        num_odd_dimensions = sum(sum(mod(feature_sz_choices, 2) == 1, 1), 2);
        [~, best_choice] = max(num_odd_dimensions(:));
        pixels_added = best_choice - 1;
        feature_info.img_sample_sz = round(new_img_sample_sz + pixels_added);
    else
        error('Unknown size_mode');
    end
    
    % Setting the feature size and support size
    %     feature_info.data_sz = floor(bsxfun(@rdivide, feature_info.img_sample_sz, feature_info.min_cell_size));
    feature_info.img_support_sz = feature_info.img_sample_sz;% 重新修改搜索区域的大小
end

% Set the sample size and data size for each feature
feature_info.data_sz_block = cell(num_features,1); %除以cell=4之后的大小
for k = 1:length(features)
    if features{k}.is_cnn
        % CNN features have a different sample size, since the receptive
        % field is often larger than the support size
        features{k}.img_sample_sz = feature_info.img_sample_sz(:)';
        
        % Set the data size based on the computed output size
        feature_info.data_sz_block{k} = floor(bsxfun(@rdivide, cnn_output_sz, features{k}.fparams.downsample_factor'));
    else
        % implemented classic features always have the same sample and
        % support size
        features{k}.img_sample_sz = feature_info.img_support_sz(:)';
        features{k}.img_input_sz = features{k}.img_sample_sz;
      
        % Set data size based on cell size   data_sz_block
        feature_info.data_sz_block{k} = floor(bsxfun(@rdivide, features{k}.img_sample_sz, features{k}.fparams.cell_size));
    end
end

feature_info.data_sz = cell2mat(feature_info.data_sz_block);%转换成矩阵