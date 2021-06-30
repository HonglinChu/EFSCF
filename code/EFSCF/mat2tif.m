function [] = mat2tif(tifName,data)
data = double(data);
[~, ~, p] = size(data);
% t = Tiff('my.tif','w');
% t = Tiff('Indiana.tif','w');
% t = Tiff('Indiana_EMP.tif','w');
% t = Tiff('Indiana_Gabor.tif','w');
% t = Tiff('PaviaUniversity.tif','w');
% t = Tiff('meadows.tif','w');
% t = Tiff('bitumen.tif','w');
% t = Tiff('ksc_part.tif','w');
t = Tiff(tifName,'w');
tagstruct.ImageLength = size(data,1); % 影像的长度
tagstruct.ImageWidth = size(data,2);  % 影像的宽度

% 颜色空间解释方式，详细见下文3.1节
tagstruct.Photometric = 1;

% 每个像素的数值位数，single为单精度浮点型，对于32为系统为32
tagstruct.BitsPerSample = 64;
% 每个像素的波段个数，一般图像为1或3，但是对于遥感影像存在多个波段所以常常大于3
tagstruct.SamplesPerPixel = p;
tagstruct.RowsPerStrip = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% 表示生成影像的软件
tagstruct.Software = 'MATLAB'; 
% 表示对数据类型的解释
tagstruct.SampleFormat = 3;
% 设置Tiff对象的tag
t.setTag(tagstruct);

% 以准备好头文件，开始写数据
t.write(data);
% 关闭
t.close;
end