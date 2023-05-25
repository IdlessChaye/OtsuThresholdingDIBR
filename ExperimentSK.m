close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

K_L = [
    1773.6720226846651,  0,  512;
0,  1773.6720226846651, 384;
0,  0,  1
    ];
K_R = K_L;
K_V = K_R;
Rt_L = [9.99997550e-01,-3.36969677e-04,-2.18778620e-03,5.64201028e+00;
3.37549410e-04,9.99999908e-01,2.64622493e-04,-8.45985515e-01;
2.18769683e-03,-2.65360331e-04,9.99997572e-01,1.78633524e+00];
Rt_R = [9.99998357e-01,-2.42708213e-04,-1.79633197e-03,4.48069725e+00;
2.43338245e-04, 9.99999909e-01,3.50522011e-04,-8.49905428e-01;
1.79624673e-03,-3.50958551e-04,9.99998325e-01,1.78638758e+00];
Rt_V = (Rt_L+Rt_R)/2;

C_L_O_path = 'mat/SongKai/CL.png';
C_R_O_path = 'mat/SongKai/CR.png';
D_L_O_path = 'mat/SongKai/DL.png';
D_R_O_path = 'mat/SongKai/DR.png';

C_L_O = double(imread(C_L_O_path));
C_R_O = double(imread(C_R_O_path));
D_L_O = double(imread(D_L_O_path));
D_R_O = double(imread(D_R_O_path));

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
