% yuebaobaoyou buchubug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

is_dibr_do_refinement = false;
layer_number = 3; % 分层数
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

LoadBallet; % 数据集，Ballet
% LoadBreakdancers; % 数据集，Breakdancers
frame = 0;
cam_L = 3;
cam_R = 5;
cam_V = 4;
LoadBalletData;
% LoadBreakdancersData;

% imwrite(uint8(D_L_O), 'mat/D_0.png');
layer_thresh_L = multithresh(D_L_O, layer_number - 1);
thresh1 = layer_thresh_L(1);
thresh2 = layer_thresh_L(2);

[H,W,N] = size(D_L_O);
ColorMap = zeros(H,W,3);
Color1 = ColorMap(:,:,1);
Color2 = ColorMap(:,:,2);
Color3 = ColorMap(:,:,3);

% index = D_L_O < thresh1;
% Color1(index) = 134;
% Color2(index) = 170;
% Color3(index) = 210;
% imwrite(uint8(cat(3, Color1, Color2, Color3)), 'mat/D_1.png');

% index = D_L_O >= thresh1 & D_L_O < thresh2;
% Color1(index) = 175;
% Color2(index) = 211;
% Color3(index) = 217;
% imwrite(uint8(cat(3, Color1, Color2, Color3)), 'mat/D_2.png');

index = D_L_O > thresh2;
Color1(index) = 242;
Color2(index) = 236;
Color3(index) = 175;
imwrite(uint8(cat(3, Color1, Color2, Color3)), 'mat/D_3.png');

% ColorMap = uint8(cat(3, Color1, Color2, Color3));
% imshow(ColorMap);
% imwrite(uint8(cat(3, Color1, Color2, Color3)), 'mat/D_all.png');


