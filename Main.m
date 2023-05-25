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

LoadClassroom;
%LoadBallet; % 数据集，Ballet
%LoadBreakdancers; % 数据集，Breakdancers
%LoadBallet2; % COLMAP数据集，Ballet
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
%figure; imshow(C_V_O); title('原新视点图像'); drawnow;
[C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);

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

%imwrite(C_V, 'classroom.jpg')
