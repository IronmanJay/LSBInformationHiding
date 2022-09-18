%% 提取LSB算法嵌入的水印
function OutputImage = LSB_Decode(InputImage,m,n)
% InputImage为含有水印的图像 ，m为要提取水印的行，n为要提取水印的列
% zeros(m,n)生成一个m*n的全0矩阵
% bitget(InputImage(i,j),1)获取图像InputImage中一个像素点的亮度值
% 将该亮度值用二进制表示，bitget(InputImage(i,j),1)中的1表示获取最低位的值
OutputImage = zeros(m,n);
for i = 1:m
    for j = 1:n
        if bitget(InputImage(i,j),1) == 1
            OutputImage(i,j) = 255;
        else
            continue;
        end
    end
end
