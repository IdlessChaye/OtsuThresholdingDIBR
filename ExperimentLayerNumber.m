% % 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear;
% clc;
% 
% addpath('./PSNR_SSIM_in_matlab');
% 
% %% Params
% 
% is_dibr_do_refinement = false;
% Zfar = 0; % 视点最远距离，在数据集文件中设置
% Znear = 0; % 视点最近距离，在数据集文件中设置
% 
% psnr_s = zeros(1, 10);
% ssim_s = zeros(1, 10);
% 
% %% Datasets
% 
% LoadBallet; % 数据集，Ballet
% frame = 0;
% cam_L = 3;
% cam_R = 5;
% cam_V = 4;
% for layer_number = 1 : 10
%     LoadBalletData;
% 
%     [C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
% 
%     psnr = metrix_psnr(C_V,C_V_O);
%     ssim = metrix_ssim(C_V,C_V_O);
%     fprintf('frame = %d, psnr = %f, ssim = %f\n',frame, psnr, ssim);
% 
%     psnr_s(layer_number) = psnr;
%     ssim_s(layer_number) = ssim;
% end
% 
% save layerNumber;


% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

is_dibr_do_refinement = false;
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

psnr_s = zeros(1, 10);
ssim_s = zeros(1, 10);

%% Datasets

LoadBallet; % 数据集，Ballet
frame = 0;
cam_L = 3;
cam_R = 5;
cam_V = 4;
for layer_number = 1 : 10
    LoadBalletData;
    switch_ablation = [1,1,0,0];
    [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);

    psnr = metrix_psnr(C_V,C_V_O);
    ssim = metrix_ssim(C_V,C_V_O);
    fprintf('frame = %d, psnr = %f, ssim = %f\n',frame, psnr, ssim);

    psnr_s(layer_number) = psnr;
    ssim_s(layer_number) = ssim;
end

save layerNumberAblation;