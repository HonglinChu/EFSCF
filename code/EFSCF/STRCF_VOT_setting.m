function results = STRCF_VOT_setting(seq, res_path, bSaveImage)
setup_paths();
% Feature specific parameters
% Feature specific parameters

% Feature specific parameters
hog_params.cell_size = 4;
hog_params.compressed_dim = 10; %hog特征压缩到10个维度？？？
hog_params.nDim = 31; % hog特征是31个维度

grayscale_params.colorspace='gray';%灰度图
grayscale_params.cell_size = 4;

cn_params.tablename = 'CNnorm'; %CN 
cn_params.useForGray = false;
cn_params.cell_size = 4;
cn_params.nDim = 10;

% Which features to include  结构体赋值  t_features.getFeature对应不同的函数
params.t_features = {  
    struct('getFeature',@get_colorspace, 'fparams',grayscale_params),...    
    struct('getFeature',@get_fhog,'fparams',hog_params),...
    struct('getFeature',@get_table_feature, 'fparams',cn_params),...
};

% Global feature parameters1s
params.t_global.cell_size = 4;                  % Feature cell size

% Image sample parameters，搜索区域是padding区域
params.search_area_shape = 'square';    % The shape of the samples
params.search_area_scale = 5;           % The scaling of the target size to get the search area
params.min_image_sample_size = 150^2;   % Minimum area of image samples
params.max_image_sample_size = 200^2;   % Maximum area of image samples

% Spatial regularization window_parameters  滤波器h/f的正则参数w最大的值和最小的值
params.feature_downsample_ratio = [4];  %Feature downsample ratio 因为 cell=4
params.reg_window_max = 1e5;            %The maximum value of the regularization window
params.reg_window_min = 1e-3;           %the minimum value of the regularization window

% Detection parameters
params.refinement_iterations = 1;       % Number of iterations used to refine the resulting position in a frame
params.newton_iterations = 5;           % The number of Newton iterations used for optimizing the detection score
params.clamp_position = false;          % ？？？Clamp the target position to be inside the image

% Learning parameters
params.output_sigma_factor = 1/16;		% Label function sigma
params.temporal_regularization_factor = [15 15]; %这里为什么是两个参数？？？The temporal regularization parameters

% ADMM parameters
params.max_iterations = [2 2];%这里这也是两个？？
params.init_penalty_factor = [1 1];%？？
params.max_penalty_factor = [0.1, 0.1];%？？
params.penalty_scale_step = [10, 10];%？？

% Scale parameters for the translation model
% Only used if: params.use_scale_filter = false
params.number_of_scales = 5;              % Number of scales to run the detector
params.scale_step = 1.01;                 % The scale factor

% Visualization
if nargin==1
  params.visualization = 0;               % Visualiza tracking and detection scores
else
  params.visualization = 0; 
end
% GPU 不适用个gpu
params.use_gpu = false;                 % Enable GPU or not
params.gpu_id = [];                     % Set the GPU id, or leave empty to use default

% Initialize
'1'
seq
'2'
params.seq = seq;

% Run tracker
results = tracker(params);
