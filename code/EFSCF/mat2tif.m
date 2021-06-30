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
tagstruct.ImageLength = size(data,1); % Ӱ��ĳ���
tagstruct.ImageWidth = size(data,2);  % Ӱ��Ŀ��

% ��ɫ�ռ���ͷ�ʽ����ϸ������3.1��
tagstruct.Photometric = 1;

% ÿ�����ص���ֵλ����singleΪ�����ȸ����ͣ�����32ΪϵͳΪ32
tagstruct.BitsPerSample = 64;
% ÿ�����صĲ��θ�����һ��ͼ��Ϊ1��3�����Ƕ���ң��Ӱ����ڶ���������Գ�������3
tagstruct.SamplesPerPixel = p;
tagstruct.RowsPerStrip = 16;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
% ��ʾ����Ӱ������
tagstruct.Software = 'MATLAB'; 
% ��ʾ���������͵Ľ���
tagstruct.SampleFormat = 3;
% ����Tiff�����tag
t.setTag(tagstruct);

% ��׼����ͷ�ļ�����ʼд����
t.write(data);
% �ر�
t.close;
end