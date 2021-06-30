function results = tracker(params)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Initialization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get sequence info

[seq, im] = get_sequence_info(params.seq); %imshow(im);读取第一张图片

params = rmfield(params, 'seq');%删除结构成员函数seq

if isempty(im)%如果图像是空
    seq.rect_position = [];
    [~, results] = get_sequence_results(seq);
    return;
end

% Init position
pos = seq.init_pos(:)';       %中心位置坐标345 282
target_sz = seq.init_sz(:)';  %目标的实际高和宽
params.init_sz = target_sz;   %初始化目标的高和宽

% Feature settings
features = params.t_features;%包含三个特征提取的函数，get_colorspace, get_hog , get_table_features

% Set default parameters
params = init_default_params(params);

% Global feature parameters
if isfield(params, 't_global')
    global_fparams = params.t_global;%params.t_global.cell_size = 4; % Feature cell size
else
    global_fparams = [];
end

global_fparams.use_gpu = params.use_gpu;
global_fparams.gpu_id = params.gpu_id;

% Define data types
if params.use_gpu
    params.data_type = zeros(1, 'single', 'gpuArray');
else
    params.data_type = zeros(1, 'single');%设置数据类型
end
params.data_type_complex = complex(params.data_type);%0.0000 + 0.0000i

global_fparams.data_type = params.data_type;

% Load learning parameters
admm_max_iterations = params.max_iterations;
init_penalty_factor = params.init_penalty_factor;
max_penalty_factor = params.max_penalty_factor;%??
penalty_scale_step = params.penalty_scale_step;%???
temporal_regularization_factor = params.temporal_regularization_factor;%????? 

init_target_sz = target_sz;

% Check if color image道   %wo觉得这里简单处理一下就可以，如果是单通道就复制成多通
if size(im,3) == 3
    if all(all(im(:,:,1) == im(:,:,2)))%感觉这里判断不够严谨
        is_color_image = false;
    else
        is_color_image = true;
    end
else
    is_color_image = false; %非彩色图像
end

if size(im,3) > 1 && is_color_image == false %如果是三个通道，并且三个通道相等 那么就判定不是彩色图像
    im = im(:,:,1);%既然三个通道相等那就只要第一个通道的
end

% Check if mexResize is available and show warning otherwise.
params.use_mexResize = true;% 可以使用 mexResize函数
global_fparams.use_mexResize = true;
try%判断mexResize函数是否可以使用
    [~] = mexResize(ones(5,5,3,'uint8'), [3 3], 'auto');
catch err
    params.use_mexResize = false;
    global_fparams.use_mexResize = false;
end

if isfield(seq,'scale')
     params.search_area_scale=seq.scale;
else
      params.search_area_scale=5;
end

%init_target_sz原始目标大小 search_area_scale=5 代表目标区域扩大5倍
% Calculate search area and initial scale factor
search_area = prod(init_target_sz * params.search_area_scale);%init_target_sz 没有padding的原始目标大小总共检索区域面积62835
if search_area > params.max_image_sample_size% 大于最大值40000则对区域searcharea进行缩小，宽和高同时缩小相同的倍数
    currentScaleFactor = sqrt(search_area / params.max_image_sample_size);
elseif search_area < params.min_image_sample_size% 小于22500，则扩大相同的倍数
    currentScaleFactor = sqrt(search_area / params.min_image_sample_size);
else
    currentScaleFactor = 1.0; %在22500~40000之间，则初始化的时候尺度因子不变
end

% target size at the initial scale
base_target_sz = target_sz / currentScaleFactor;%对初始化的目标区域进行resize, 22500<base_target_sz×5<40000 
% window size, taking padding into account
switch params.search_area_shape%搜索区域是一个square  base_target_sz * params.search_area_scale是扩大5倍之后的搜索区域
    case 'proportional'
        img_sample_sz = floor(base_target_sz * params.search_area_scale);     % proportional area, same aspect ratio as the target
    case 'square'%200x200，搜索区域的选择而没有考虑纵横比
        img_sample_sz = repmat(sqrt(prod(base_target_sz * params.search_area_scale)), 1, 2); % square area, ignores the target aspect ratio
    case 'fix_padding'
        img_sample_sz = base_target_sz + sqrt(prod(base_target_sz * params.search_area_scale) + (base_target_sz(1) - base_target_sz(2))/4) - sum(base_target_sz)/2; % const padding
    case 'custom'
        img_sample_sz = [base_target_sz(1)*2 base_target_sz(2)*2];
end

%features是特征提取函数结构体，有三种类型特征  %global_fparams 主要包含cell的大小和是否使用gpu %is_color_image
[features, global_fparams, feature_info] = init_features(features, global_fparams, is_color_image, img_sample_sz, 'exact');

% Set feature info 
img_support_sz = feature_info.img_support_sz;%四舍五入之后的img_support_sz=round(new_img_sample_sz + pixels_added);
feature_sz = unique(feature_info.data_sz, 'rows', 'stable');%feature_info.data_sz=img_support_sz/cell_size
feature_cell_sz = unique(feature_info.min_cell_size, 'rows', 'stable');
num_feature_blocks = size(feature_sz, 1);%因为三种特征都是使用同一个特征尺寸 50x50;所以feature_blocks 的数量等于1 

% Get feature specific parameters
feature_extract_info = get_feature_extract_info(features);%获取 image_sample_size 和 image_input_size

% Size of the extracted feature maps    
feature_sz_cell = mat2cell(feature_sz, ones(1,num_feature_blocks), 2);
filter_sz = feature_sz;%50 x 50 特征图的大小和filter_sz的大小保持一致
filter_sz_cell = permute(mat2cell(filter_sz, ones(1,num_feature_blocks), 2), [2 3 1]);

% The size of the label function DFT. Equal to the maximum filter size
[output_sz, k1] = max(filter_sz, [], 1);%找到最大的滤波器的大小
k1 = k1(1);

% Get the remaining block indices  num_feature_blocks因为所有的特征都是同意尺寸，所以==1
block_inds = 1:num_feature_blocks;
block_inds(k1) = [];

% Construct the Gaussian label function   yfcell中只有一个尺寸
yf = cell(numel(num_feature_blocks), 1);
for i = 1:num_feature_blocks
    sz = filter_sz_cell{i};
    output_sigma = sqrt(prod(floor(base_target_sz/feature_cell_sz(i)))) * params.output_sigma_factor;
    rg           = circshift(-floor((sz(1)-1)/2):ceil((sz(1)-1)/2), [0 -floor((sz(1)-1)/2)]);
    cg           = circshift(-floor((sz(2)-1)/2):ceil((sz(2)-1)/2), [0 -floor((sz(2)-1)/2)]);
    [rs, cs]     = ndgrid(rg,cg);
    y            = exp(-0.5 * (((rs.^2 + cs.^2) / output_sigma^2)));
    yf{i}        = fft2(y); %imshow(real(fft2(y));循环移动位置，0频移动到四个角落
end

% Compute the cosine windows imshow
cos_window = cellfun(  @(sz) hann(sz(1))*hann(sz(2))', feature_sz_cell, 'uniformoutput', false);

%ratio2=0.95;
if isfield(seq,'ratio2')
     ratio2=seq.ratio2;
 else
     ratio2=1;
end
% Define spatial regularization windows imshow((cell2mat(cos_window)));
reg_window = cell(num_feature_blocks, 1);
for i = 1:num_feature_blocks
   
    reg_scale = floor(ratio2*base_target_sz/params.feature_downsample_ratio(i));
    use_sz = filter_sz_cell{i}; %搜索区域对应的滤波器的大小  
    reg_window{i} = ones(use_sz) * params.reg_window_max;%所有的数字都是最大数值
    range = zeros(numel(reg_scale), 2);
    
    % determine the target center and range in the regularization windows
    for j = 1:numel(reg_scale) %numel(reg_scale)=2
        range(j,:) = [0, reg_scale(j) - 1] - floor(reg_scale(j) / 2);
    end
    center = floor((use_sz + 1)/ 2) + mod(use_sz + 1,2); %四舍五入？？？
    range_h = (center(1)+ range(1,1)) : (center(1) + range(1,2));
    range_w = (center(2)+ range(2,1)) : (center(2) + range(2,2));
    
    reg_window{i}(range_h, range_w) = params.reg_window_min; %目标区域都是最小值,接近1，其他区域都是无穷大
end %imshow(cell2mat(reg_window)); surf(reg_window{i});%这里和倒高斯还是有点区别的
%ky和kx用在尺度估计上

% Pre-computes the grid that is used for socre optimization
ky = circshift(-floor((filter_sz_cell{1}(1) - 1)/2) : ceil((filter_sz_cell{1}(1) - 1)/2), [1, -floor((filter_sz_cell{1}(1) - 1)/2)]);
kx = circshift(-floor((filter_sz_cell{1}(2) - 1)/2) : ceil((filter_sz_cell{1}(2) - 1)/2), [1, -floor((filter_sz_cell{1}(2) - 1)/2)])';
newton_iterations = params.newton_iterations;

% Use the translation filter to estimate the scale
nScales = params.number_of_scales;
scale_step = params.scale_step;
scale_exp = (-floor((nScales-1)/2):ceil((nScales-1)/2));
scaleFactors = scale_step .^ scale_exp;

if nScales > 0 %  min_scale_factor=0.0252;  max_scale_factor=11.6783
    %force reasonable scale changes
    min_scale_factor = scale_step ^ ceil(log(max(5 ./ img_support_sz)) / log(scale_step));
    max_scale_factor = scale_step ^ floor(log(min([size(im,1) size(im,2)] ./ base_target_sz)) / log(scale_step));
end

seq.time = 0;

% Define the learning variables
f_pre_f = cell(num_feature_blocks, 1);  %
cf_f = cell(num_feature_blocks, 1); %

% Allocate
scores_fs_feat = cell(1,1,num_feature_blocks); %1x1的矩阵

while true 
    
    % Read image
    if seq.frame > 0
        [seq, im] = get_sequence_frame(seq);
        if isempty(im)
            break;
        end
        if size(im,3) > 1 && is_color_image == false
            im = im(:,:,1);
        end
    else
        seq.frame = 1; %第一帧
    end

    tic();
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Target localization step
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Do not estimate translation and scaling on the first frame, since we 
    % just want to initialize the tracker there
    if seq.frame > 1 %不是第一帧
        old_pos = inf(size(pos));  %inf是无穷大量 -inf是无穷小量
        iter = 1;
        %translation search
        while iter <= params.refinement_iterations && any(old_pos ~= pos)
            % Extract features at multiple resolutions
            sample_pos = round(pos);                        %四舍五入
            sample_scale = currentScaleFactor*scaleFactors; %进行多尺度变换
            [xt,img_samples]= extract_features(im, sample_pos, sample_scale, features, global_fparams, feature_extract_info);
            %提取5个尺度下的特征   xt = 50x50x42x5                
            % Do windowing of features  %提取特征然后在特征上添加 cos window 注意区别 先在图像上添加cos window然后再提取特征的区别
            xtw = cellfun(@(feat_map, cos_window) bsxfun(@times, feat_map, cos_window), xt, cos_window, 'uniformoutput', false);
            %提取特征
            % Compute the fourier series
            xtf = cellfun(@fft2, xtw, 'uniformoutput', false); % 转换到频域
                        
            % Compute convolution for each feature block in the Fourier domain
            % and the sum over all blocks. gather和gpu操作有关系每一个通道进行卷积操作
            scores_fs_feat{k1} = gather(sum(bsxfun(@times, conj(cf_f{k1}), xtf{k1}), 3));
            scores_fs_sum = scores_fs_feat{k1};
            for k = block_inds  % block_inds=empty,所以这里不需要进行设置
                scores_fs_feat{k} = gather(sum(bsxfun(@times, conj(cf_f{k}), xtf{k}), 3));
                scores_fs_feat{k} = resizeDFT2(scores_fs_feat{k}, output_sz);
                scores_fs_sum = scores_fs_sum + scores_fs_feat{k};
            end
            
            % Also sum over all feature blocks.
            % Gives the fourier coefficients of the convolution response.
            scores_fs = permute(gather(scores_fs_sum), [1 2 4 3]);%scores_fs_sum=50x50x1x5
            %scores_fs_sum=50x50x5x1    5代表5个尺度，50x50代表每个尺度上的响应
            responsef_padded = resizeDFT2(scores_fs, output_sz);% 统一 一下尺度
            response = ifft2(responsef_padded, 'symmetric');%转换到实域
            [disp_row, disp_col, sind] = resp_newton(response, responsef_padded, newton_iterations, ky, kx, output_sz);
            % 梯度下降法求极大值，可以精确到亚像素级别  
            % Compute the translation vector in pixel-coordinates and round
            % to the closest integer pixel.   
            translation_vec = [disp_row, disp_col] .* (img_support_sz./output_sz) * currentScaleFactor * scaleFactors(sind);            
            scale_change_factor = scaleFactors(sind);
            
            % update position
            old_pos = pos;
            pos = sample_pos + translation_vec;%translation_vec是相对上一帧位置的偏移，在没有缩放的图像块上
            
            if params.clamp_position  %这一步直接跳过
                pos = max([1 1], min([size(im,1) size(im,2)], pos));
            end
                        
            % Update the scale
            currentScaleFactor = currentScaleFactor * scale_change_factor; %代表当前新的尺度
            
            % Adjust to make sure we are not to large or to small  确保尺度因子不会太大或者太小
            if currentScaleFactor < min_scale_factor
                currentScaleFactor = min_scale_factor;
            elseif currentScaleFactor > max_scale_factor
                currentScaleFactor = max_scale_factor;
            end
            
            iter = iter + 1;
        end
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Model update step
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % extract image region for training sample
    sample_pos = round(pos);% 四舍五入，pos是当前帧的位置
    [xl,~] = extract_features(im, sample_pos, currentScaleFactor, features, global_fparams, feature_extract_info);
    %x1=50x50x42  1 gray + 31 hog + 10 cn
    % do  windowing  of  features
    xlw = cellfun(@(feat_map, cos_window) bsxfun(@times, feat_map, cos_window), xl, cos_window, 'uniformoutput', false);
    %对提取的特征添加cos窗口
    %compute the fourier series
    xlf = cellfun(@fft2, xlw, 'uniformoutput', false);% 50x50x42
    
    % train the CF model for each feature
    for k = 1: numel(xlf)  %只循环一次
        model_xf = xlf{k}; %50x50x42

        if (seq.frame == 1)
            f_pre_f{k} = zeros(size(model_xf));% y_pre_f代表 频域标签y_pre_f=50x50x42 ，model_xf
            mu = 0; 
        else
            mu = temporal_regularization_factor(k);
              %ratio2=0.95;
            if isfield(seq,'lambda2')
                 mu=seq.lambda2;
            end
        end
        
        % intialize the variables
        f_f = single(zeros(size(model_xf)));
        g_f = f_f;
        h_f = f_f;
        
        gamma  = init_penalty_factor(k);  % 1  , 1
        %gamma=0.05;
        gamma_max = max_penalty_factor(k);% 0.1, 0.1
        gamma_scale_step = penalty_scale_step(k); %10
        
        % use the GPU mode  这里可以忽略
        if params.use_gpu
            model_xf = gpuArray(model_xf);
            f_f = gpuArray(f_f);
            f_pre_f{k} = gpuArray(f_pre_f{k});
            g_f = gpuArray(g_f);
            h_f = gpuArray(h_f);
            reg_window{k} = gpuArray(reg_window{k});
            yf{k} = gpuArray(yf{k});
        end

        % pre-compute the variables
        T = prod(output_sz);         %50x50
        S_xx = sum(conj(model_xf) .* model_xf, 3);% 50x50  42个通道合并成一个通道 S_xx
        Sf_pre_f = sum(conj(model_xf) .* f_pre_f{k}, 3);%S_xy  这一步的计算在 Multi_channel 有体现
        Sfx_pre_f = bsxfun(@times, model_xf, Sf_pre_f); %?????
        % solve via ADMM algorithm
        iter = 1;      
        d=ones(output_sz(1),1);
        eps=0.00001;
        admm_max_iterations=2;
        while (iter <= admm_max_iterations) %最大迭代两次
            
            % STRCF  loss-term L2-norm
            %solve_f;
            
            % EFSCF  loss-term L2,1-norm 
            solve_f_2;
            
            if iter==2
                break;
            end
            
            X=real(ifft2(gamma * f_f + h_f));% 
            if (seq.frame==1) 
                g_f = fft2(argmin_g(reg_window{k}, gamma, X, g_f)); %gamma=mu
            else
                small_filter_sz=floor(base_target_sz/feature_cell_sz);
                % g_f = fft2(argmin_g_2(reg_window{k}, gamma, X , g_f,seq)); % gamma=mu
                g_f = fft2(argmin_g_3(reg_window{k}, gamma, X , g_f,seq,small_filter_sz,output_sz)); % gamma=mu
            end
            
            %imagesc(real(g_f(:,:,1)));
            %h_f = h_f + (gamma * (f_f - g_f));
            h_f = h_f + (f_f - g_f);
            %update gamma
            gamma = min(gamma_scale_step * gamma, gamma_max);% 这里的gamma的值和bacf论文里面的值不一样
            
            iter = iter+1;
        end
        % save the trained filters
        f_pre_f{k} = f_f;
        %这里并没有使用学习率
        %----------------------------------------------------%
        cf_f{k} = f_f;  % 多通道滤波器STRCF   
        %-----------------------------------------------------%
    end  
           
    % Update the target size (only used for computing output box)
    target_sz = base_target_sz * currentScaleFactor;
    %save position and calculate FPS
    tracking_result.center_pos = double(pos);
    tracking_result.target_size = double(target_sz);
    seq = report_tracking_result(seq, tracking_result);
    
    seq.time = seq.time + toc();
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Visualization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % visualization
    params.visualization=0;
    if params.visualization
%---------------------------------------------------------------------------------%
%         rect_position_vis = [pos([2,1]) - (target_sz([2,1]) - 1)/2, target_sz([2,1])];
%         im_to_show = double(im)/255;
%         if size(im_to_show,3) == 1
%             im_to_show = repmat(im_to_show, [1 1 3]);
%         end
%         figure(1)
%         imagesc(im_to_show);
%         hold on;
%         rectangle('Position',rect_position_vis, 'EdgeColor','g', 'LineWidth',2);
%         text(10, 10, [int2str(seq.frame) '/'  int2str(size(seq.image_files, 1))], 'color', [0 1 1]);
%         hold off;
%         axis off;axis image;set(gca, 'Units', 'normalized', 'Position', [0 0 1 1])
%                     
%        drawnow
         %--------------------------------------------------------------------------%
         % Visualization  of response
         vis_response;
        
         %---------------------------------------------------------------------------%
    end
    
end

[~, results] = get_sequence_results(seq);

% disp(['fps: ' num2str(results.fps)])

