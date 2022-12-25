% ������ֵ�˲���ֱ����ֵ�˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

%% Params

layer_number = 3; % �ֲ���
Zfar = 0; % �ӵ���Զ���룬�����ݼ��ļ�������
Znear = 0; % �ӵ�������룬�����ݼ��ļ�������

% LoadBallet; % ���ݼ���Ballet
LoadBreakdancers; % ���ݼ���Breakdancers
frame = 0;
cam_L = 3;
cam_R = 5;
cam_V = 4;
% LoadBalletData;
LoadBreakdancersData;

%% DIBR Algorithm
figure; imshow(C_V_O); title('ԭ���ӵ�ͼ��'); drawnow;
[C_V] = dibrAblationMedian(layer_number, Znear, Zfar, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V);

%% Experiments

% result image

figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;

% PSNR

psnr = mPSNR(C_V,C_V_O,8);
fprintf('psnr = %f\n',psnr);

% SSIM

ssim = mSSIM(C_V,C_V_O);
fprintf('ssim = %f\n',ssim);

% save result
% imwrite(C_V, ['ExAbMedian12BalletResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
imwrite(C_V, ['ExAbMedian12BreakResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
