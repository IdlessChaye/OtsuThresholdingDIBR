close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');



is_dibr_do_refinement = false;
layer_number = 3; % 分层数
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

LoadBallet; % 数据集，Ballet 
% LoadBreakdancers; % 数据集，Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;

psnr_s = zeros(1, 100);
ssim_s = zeros(1, 100);
for frame = 0 : 99
    LoadBalletData;
    % LoadBreakdancersData;
    
    [C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
    
    psnr = metrix_psnr(C_V,C_V_O);
    ssim = metrix_ssim(C_V,C_V_O);
    fprintf('frame = %d, psnr = %f, ssim = %f\n',frame, psnr, ssim);
    
    psnr_s(frame + 1) = psnr;
    ssim_s(frame + 1) = ssim;
end

fprintf('ave psnr = %f\n',sum(psnr_s) / 100);
fprintf('ave ssim = %f\n',sum(ssim_s) / 100);

save ba;


clear;

is_dibr_do_refinement = false;
layer_number = 3; % 分层数
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

% LoadBallet; % 数据集，Ballet 
LoadBreakdancers; % 数据集，Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;

psnr_s = zeros(1, 100);
ssim_s = zeros(1, 100);
for frame = 0 : 99
    % LoadBalletData;
    LoadBreakdancersData;
    
    [C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
    
    psnr = metrix_psnr(C_V,C_V_O);
    ssim = metrix_ssim(C_V,C_V_O);
    fprintf('frame = %d, psnr = %f, ssim = %f\n',frame, psnr, ssim);
    
    psnr_s(frame + 1) = psnr;
    ssim_s(frame + 1) = ssim;
end

fprintf('ave psnr = %f\n',sum(psnr_s) / 100);
fprintf('ave ssim = %f\n',sum(ssim_s) / 100);

save br;



% Ballet
% ave psnr = 31.782208 32.35
% ave ssim = 0.891302 0.8946

% Breakdancers
% ave psnr = 31.082321 31.71
% ave ssim = 0.873696 0.8785
