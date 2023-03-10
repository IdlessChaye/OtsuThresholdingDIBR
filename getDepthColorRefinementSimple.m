function [D, C] = getDepthColorRefinementSimple(D_O, C_O)
%DepthColorRefinement
% 先对深度图进行开操作，使深度图的小矛刺消失
% 再对深度图进行双边滤波，保障保边平滑
% 然后对深度图进行边缘检测，并对边缘膨胀一个像素，深度图边缘处的彩色不可信
% 对彩色图进行镂空和填补，彩色图的填补根据深度来确定，保障所填补的像素属于相近深度，选择基于双边滤波进行基于颜色图的空间邻域、深度相似的双边滤波
% D_O H*W   double 输入的深度图
% C_O H*W*3 double 输入的颜色图
% D   H*W   double 输出的深度图
% C   H*W*3 double 输出的颜色图
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_show_figure = false;

z_sign = D_O(1) / abs(D_O(1));
D_O = D_O * z_sign;

if is_show_figure
    figure;
    imshow(uint8(D_O));
end

%D = D_open(:,:,1);
depth_sigma_w = 3;   % spatial sigma
depth_sigma_c = 10;	 % value sigma
depth_window = 2;	 % window size - radius
D = getDepthBilateralFilter(D_O,depth_sigma_w,depth_sigma_c,depth_window);
if is_show_figure
    figure;
    imshow(uint8(D));
end

C = C_O;
D = D * z_sign;

end