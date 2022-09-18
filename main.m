clc;%清除命令行窗口
close all;%关闭所有打开的窗口
clear all;%清除工作空间

%获取载体图像并将其转化为灰度图
CarrierImg = rgb2gray(imread('lena.bmp')); 
% 获取载体图像的行M和列N
[M, N] = size(CarrierImg);
% 显示载体图像
figure, imshow(CarrierImg);
title('载体图像');

%获取要隐藏的水印图像并将其转化为灰度图
BinImg = rgb2gray(imread('SmallPig.bmp'));
% 获取水印图像的行m和列m
[m, n] = size(BinImg);
% 比较载体图像和水印图像，若水印图像的行和列均小于载体图像，不做处理
% 反之，若有水印图像的行或列大于载体图像，则将水印图像调整和载体图像一样大来嵌入
if m>M || n>N
    BinImg = imresize(BinImg,[M,N]);
end
% 将水印图像进行二值化处理，先转化为double,阈值根据水印图片自行调节
% imbinarize(BinImg,0.90)以0.90为阈值将BinImg转化为二值图像
% 大于0.90的变成逻辑1（白色），小于0.90的变成逻辑0(黑色)
BinImg = im2double(BinImg);
BinImg = imbinarize(BinImg,0.90);
% 显示处理后的水印图像
figure, imshow(BinImg);
title('需要被隐藏二值化图像');

%% 嵌入水印
WatermarketImg = LSB_Encode(CarrierImg,BinImg,M,N,m,n);
figure,imshow(WatermarketImg);
imwrite(WatermarketImg,'WatermarketImg.bmp');

%% 提取水印
% Image = imread('WatermarketImg.bmp');
% BinImage = LSB_Decode(Image,m,n);
% imshow(BinImage);
