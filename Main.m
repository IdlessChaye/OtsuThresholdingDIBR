% yuebaobaoyou buchubug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

is_dibr_do_refinement = false;
layer_number = 3; % �ֲ���
Zfar = 0; % �ӵ���Զ���룬�����ݼ��ļ�������
Znear = 0; % �ӵ�������룬�����ݼ��ļ�������

LoadBallet; % ���ݼ���Ballet
% LoadBreakdancers; % ���ݼ���Breakdancers
frame = 0;
cam_L = 3;
cam_R = 5;
cam_V = 4;
LoadBalletData;
% LoadBreakdancersData;

% LoadKendo;
% frame = 50;
% LoadKendoData;

% LoadBalloons;
% frame = 50;
% LoadBalloonsData;

% LoadShark;
% frame = 50;
% LoadSharkData;

% LoadPoznanStreet;
% frame = 50;
% LoadPoznanStreetData;

% LoadPoznanHall2;
% frame = 50;
% LoadPoznanHall2Data;

%% DIBR Algorithm
figure; imshow(C_V_O); title('ԭ���ӵ�ͼ��'); drawnow;
[C_V] = dibr(layer_number, Znear, Zfar, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, is_dibr_do_refinement);

%% Experiments

% result image

figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;

% PSNR

psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);

% SSIM

ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);
