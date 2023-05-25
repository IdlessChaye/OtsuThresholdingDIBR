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

LoadClassroom;
%LoadBallet; % ���ݼ���Ballet
%LoadBreakdancers; % ���ݼ���Breakdancers
%LoadBallet2; % COLMAP���ݼ���Ballet
frame = 0;
cam_L = 2;
cam_R = 10;
cam_V = 8;
LoadClassroomData;
%LoadBalletData;
%LoadBreakdancersData;
%LoadBalletData2;

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
%figure; imshow(C_V_O); title('ԭ���ӵ�ͼ��'); drawnow;
[C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);

%% Experiments

% Color Correction

% [C_V, C_V_O] = getColorCorrected(C_V, C_V_O);


% result image

figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;

% PSNR

psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);

% SSIM

ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);

%imwrite(C_V, 'classroom.jpg')
