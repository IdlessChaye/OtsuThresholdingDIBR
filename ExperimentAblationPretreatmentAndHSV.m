% 预处理阶段的各个操作
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

%% Params

layer_number = 3; % 分层数
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

LoadBallet; % 数据集，Ballet
% LoadBreakdancers; % 数据集，Breakdancers
frame = 0;
cam_L = 3;
cam_R = 5;
cam_V = 4;

frame_num = num2str(frame,'%03d');
C_L_O_path = [pc_dir_name,'color-cam',num2str(cam_L),'-f',frame_num,'.jpg'];
C_R_O_path = [pc_dir_name,'color-cam',num2str(cam_R),'-f',frame_num,'.jpg'];
C_V_O_path = [pc_dir_name,'color-cam',num2str(cam_V),'-f',frame_num,'.jpg'];
D_L_O_path = [pd_dir_name,'depth-cam',num2str(cam_L),'-f',frame_num,'.png'];
D_R_O_path = [pd_dir_name,'depth-cam',num2str(cam_R),'-f',frame_num,'.png'];
C_L_O = double(imread(C_L_O_path));
C_R_O = double(imread(C_R_O_path));
C_V_O = imread(C_V_O_path);
D_L_O = getDepthMap(imread(D_L_O_path),Znear, Zfar);
D_R_O = getDepthMap(imread(D_R_O_path),Znear, Zfar);
K_L = Ks{cam_L + 1};
K_R = Ks{cam_R + 1};
K_V = Ks{cam_V + 1};
Rt_L = Rts{cam_L + 1};
Rt_R = Rts{cam_R + 1};
Rt_V = Rts{cam_V + 1};

%% DIBR Algorithm
figure; imshow(C_V_O); title('原新视点图像'); drawnow;
[C_V] = dibrAblationPretreatmentAndHSV(layer_number, Znear, Zfar, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V);

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
imwrite(C_V, ['ExAbPretreatmentAndHSVBalletResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
% imwrite(C_V, ['ExAbPretreatmentAndHSVBreakResult',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);