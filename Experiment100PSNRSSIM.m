close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

is_dibr_do_refinement = false;
layer_number = 3; % �ֲ���
Zfar = 0; % �ӵ���Զ���룬�����ݼ��ļ�������
Znear = 0; % �ӵ�������룬�����ݼ��ļ�������

% LoadBallet; % ���ݼ���Ballet
LoadBreakdancers; % ���ݼ���Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;

psnr_s = zeros(1, 100);
ssim_s = zeros(1, 100);
for frame = 0 : 99
    % LoadBalletData;
    LoadBreakdancersData;
    
    [C_V] = dibr(layer_number, Znear, Zfar, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, is_dibr_do_refinement);
    
    psnr = metrix_psnr(C_V,C_V_O);
    ssim = metrix_ssim(C_V,C_V_O);
    fprintf('frame = %d, psnr = %f, ssim = %f\n',frame, psnr, ssim);
    
    psnr_s(frame + 1) = psnr;
    ssim_s(frame + 1) = ssim;
end

fprintf('ave psnr = %f\n',sum(psnr_s) / 100);
fprintf('ave ssim = %f\n',sum(ssim_s) / 100);

% Breakdancers
% ave psnr = 31.316619
% ave ssim = 0.874210

% Ballet
% ave psnr = 31.789698
% ave ssim = 0.891137
