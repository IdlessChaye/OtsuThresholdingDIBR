% Otsu分层和均等分层
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

%% Params

% layer_number = 1; % 分层数
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

for layer_number = 1 : 10
%% DIBR Algorithm
figure; imshow(C_V_O); title('原新视点图像'); drawnow;
[C_V] = dibrAblationAdaptedLayered(layer_number, Znear, Zfar, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V);

%% Experiments

% result image

figure; imshow(C_V); title('DIBR合成图像结果'); drawnow;

% PSNR

psnr = mPSNR(C_V,C_V_O,8);
fprintf('psnr = %f\n',psnr);

% SSIM

ssim = mSSIM(C_V,C_V_O);
fprintf('ssim = %f\n',ssim);

% save result
imwrite(C_V, ['ExAbAdaptedLayered',num2str(layer_number),'BalletResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
% imwrite(C_V, ['ExAbAdaptedLayered',num2str(layer_number),'BreakResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
end
