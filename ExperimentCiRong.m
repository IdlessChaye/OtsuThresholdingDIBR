% yuebaobaoyou buchubug
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

layer_number = 3; % 分层数
% frame = 14; % Ballet
frame = 71; % Breakdancers


is_dibr_do_refinement = true;
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置
% LoadBallet; % 数据集，Ballet
LoadBreakdancers; % 数据集，Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;
% LoadBalletData;
LoadBreakdancersData;
figure; imshow(C_V_O); title('原新视点图像'); drawnow;
[C_V] = dibrQianCiHouCi(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
figure; imshow(C_V); title('dibrQianCiHouCi'); drawnow;
psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);
ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);
imwrite(C_V, ['dibrQianCiHouCi',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);

is_dibr_do_refinement = false;
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置
% LoadBallet; % 数据集，Ballet
LoadBreakdancers; % 数据集，Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;
% LoadBalletData;
LoadBreakdancersData;
[C_V] = dibrQianYouHouCi(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
figure; imshow(C_V); title('dibrQianYouHouCi'); drawnow;
psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);
ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);
imwrite(C_V, ['dibrQianYouHouCi',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);

is_dibr_do_refinement = true;
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置
% LoadBallet; % 数据集，Ballet
LoadBreakdancers; % 数据集，Breakdancers
cam_L = 3;
cam_R = 5;
cam_V = 4;
% LoadBalletData;
LoadBreakdancersData;
[C_V] = dibrQianCiHouYou(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
figure; imshow(C_V); title('dibrQianCiHouYou'); drawnow;
psnr = metrix_psnr(C_V, C_V_O);
fprintf('psnr = %f\n',psnr);
ssim = metrix_ssim(C_V,C_V_O); 
fprintf('ssim = %f\n',ssim);
imwrite(C_V, ['dibrQianCiHouYou',sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);