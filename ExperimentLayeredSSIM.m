% 
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

psnr_s = zeros(4, 100);
ssim_s = zeros(4, 100);

%% Datasets

LoadBallet; % 数据集，Ballet
cam_L = 3;
cam_R = 5;
cam_V = 4;
for frame = 0 : 99
    LoadBalletData;
    for k = 0 : 1
        for l = 0 : 1
            ablation_switch = [0 0 k l];

            [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement, ablation_switch);

            psnr = metrix_psnr(C_V,C_V_O);
            ssim = metrix_ssim(C_V,C_V_O);
            fprintf('frame = %d, psnr = %f, ssim = %f, k = %d, l = %d\n',frame, psnr, ssim, k, l);

            psnr_s(l + 2 * k + 1,frame + 1) = psnr;
            ssim_s(l + 2 * k + 1,frame + 1) = ssim;
        end
    end
end

save layeredSSIM;

A = ssim_s(1,:);
B = ssim_s(2,:);
C = ssim_s(3,:);
D = ssim_s(4,:);
plot(1:100, A, 1:100, B, 1:100, C, 1:100, D);
