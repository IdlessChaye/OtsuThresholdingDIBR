close all;
clear;
clc;

% addpath('./PSNR_SSIM_in_matlab');
% 
% is_dibr_do_refinement = false;
% layer_number = 3; % �ֲ���
% Zfar = 0; % �ӵ���Զ���룬�����ݼ��ļ�������
% Znear = 0; % �ӵ�������룬�����ݼ��ļ�������
% 
% % LoadBallet; % ���ݼ���Ballet
% % frame = 70;
% % cam_L = 3;
% % cam_R = 5;
% % cam_V = 4;
% % LoadBalletData;
% 
% LoadBreakdancers; % ���ݼ���Breakdancers
% frame = 6;
% cam_L = 3;
% cam_R = 5;
% cam_V = 4;
% LoadBreakdancersData;
% 
% [C_V] = dibr(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), is_dibr_do_refinement);
% figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;
% % imwrite(C_V,[pics_dir, 'ba4_70.png']);
% imwrite(C_V,[pics_dir, 'br4_06.png']);

% pics_dir = 'MSR3DVideo-Ballet/';
% C_V = imread([pics_dir, 'ba4_70.png']);
% figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;
% % C_V_Crop = imcrop(C_V, [290, 120, 160, 120]);
% % figure; imshow(C_V_Crop); title('ba4 70'); drawnow;
% % imwrite(C_V_Crop,[pics_dir, 'ba4_70_crop1.png']);
% C_V_Crop = imcrop(C_V, [300, 420, 160, 120]);
% figure; imshow(C_V_Crop); title('ba4 70'); drawnow;
% imwrite(C_V_Crop,[pics_dir, 'ba4_70_crop2.png']);

% pics_dir = 'MSR3DVideo-Breakdancers/';
% C_V = imread([pics_dir, 'br4_06.png']);
% figure; imshow(C_V); title('DIBR�ϳ�ͼ����'); drawnow;
% % C_V_Crop = imcrop(C_V, [540, 300, 160, 120]);
% % figure; imshow(C_V_Crop); title('br4 06'); drawnow;
% % imwrite(C_V_Crop,[pics_dir, 'br4_06_crop1.png']);
% C_V_Crop = imcrop(C_V, [25, 130, 160, 120]);
% figure; imshow(C_V_Crop); title('br4 06'); drawnow;
% imwrite(C_V_Crop,[pics_dir, 'br4_06_crop2.png']);



