%% LSB算法实现嵌入图片水印
function CarrierImg = LSB_Encode(CarrierImg,BinImg,M,N,m,n)
% CarrierImg为载体图像 ，BinImg为二值化后的要隐藏的水印图像
% M为载体图像的行,N为载体图像的列,m为水印图像的行，n为水印图像的列
% bitget(CarrierImg(i,j),1)获取图像CarrierImg中一个像素点的亮度值
% 将该亮度值用二进制表示，bitget(CarrierImg(i,j),1)中的1表示获取最低位的值
% 注意！！！水印图像的m*n 要小于等于载体图像的 M*N
% 即m<=M,n<=N
if (m <= M && n <= N)
    for i = 1:m
        for j = 1:n
            if BinImg(i,j) == bitget(CarrierImg(i,j),1)
                continue;
            elseif BinImg(i,j) == 0 && bitget(CarrierImg(i,j),1) ==1
                CarrierImg(i,j) = CarrierImg(i,j)-1;
            elseif BinImg(i,j) == 1 && bitget(CarrierImg(i,j),1) ==0
                CarrierImg(i,j) = CarrierImg(i,j)+1;
            end
        end
    end    
else
    fprintf('BinImg is too big than CarrierImg!!!')
end    