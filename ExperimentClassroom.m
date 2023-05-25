close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

K_L = [
    520.908620 0.000000 325.141442;
0.000000 521.007327 249.701764;
0.000000 0.000000 1.000000
    ];
K_R = K_L;
K_V = K_R;


Rt_L = [quat2dcm(quatnormalize([0.6529 -0.5480 0.3237 -0.4107])) [-0.1525 -1.4432 1.4776]'];
Rt_R = [quat2dcm(quatnormalize([0.6911 -0.5072 0.2916 -0.4244])) [-0.1862 -1.7185 1.4751]'];
Rt_V = (Rt_L+Rt_R)/2;

C_L_O_path = 'mat/Chaye/CL.png';
C_R_O_path = 'mat/Chaye/CR.png';
D_L_O_path = 'mat/Chaye/DL.png';
D_R_O_path = 'mat/Chaye/DR.png';

C_L_O = double(imread(C_L_O_path));
C_R_O = double(imread(C_R_O_path));

factor = 5000;
D_L_O = double(imread(D_L_O_path)) / factor;
D_R_O = double(imread(D_R_O_path)) / factor;

Znear_L = min(min(min(D_L_O)));
Znear_R = min(min(min(D_R_O)));
Zfar_L = max(max(max(D_L_O)));
Zfar_R = max(max(max(D_R_O)));
Znear = (Znear_L + Znear_R) / 2;
Zfar = (Zfar_L + Zfar_R) / 2;

is_dibr_do_refinement = false;
layer_number = 3; % 分层数

[C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);

figure; imshow(C_V); title('DIBR合成图像结果'); drawnow;

imwrite(uint8(C_V), 'mat/SongKai/output.png');
