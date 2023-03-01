% yuebaobaoyou buchubug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

ablation_switch = [0 1 0 0];
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

%% DIBR Algorithm

[C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement, ablation_switch);

%% Experiments

% Color Correction

% [C_V, C_V_O] = getColorCorrected(C_V, C_V_O);


% result image

figure; imshow(C_V); title('DIBR合成图像结果'); drawnow;

% PSNR

psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);

% SSIM

ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);

imwrite(C_V, ['2', sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);