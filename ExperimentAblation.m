% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
clear;
clc;

addpath('./PSNR_SSIM_in_matlab');

%% Params

layer_number = 3; % 分层数
Zfar = 0; % 视点最远距离，在数据集文件中设置
Znear = 0; % 视点最近距离，在数据集文件中设置

%% Datasets

is_dibr_do_refinement = true;
LoadBallet; % 数据集，Ballet
frame = 14;
cam_L = 3;
cam_R = 5;
cam_V = 4;
for i = 0 : 1
    for j = 0 : 1
        for k = 0 : 1
            for l = 0 : 1
                ablation_switch = [i j k l];
                is_dibr_do_refinement = i;
                LoadBalletData;

[C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), false, ablation_switch);

psnr = metrix_psnr(C_V,C_V_O);
fprintf('psnr = %f\n',psnr);

ssim = metrix_ssim(C_V,C_V_O);
fprintf('ssim = %f\n',ssim);

imwrite(C_V, ['ExAbBalletResult',num2str(i),num2str(j),num2str(k),num2str(l), sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);

            end
        end
    end
end

% 
% is_dibr_do_refinement = true;
% LoadBreakdancers; % 数据集，Breakdancers
% frame = 71;
% cam_L = 3;
% cam_R = 5;
% cam_V = 4;
% for i = 0 : 1
%     for j = 0 : 1
%         for k = 0 : 1
%             for l = 0 : 1
%                 ablation_switch = [i j k l];
%                 is_dibr_do_refinement = i;
%                 LoadBreakdancersData;
%                 
% [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), false, ablation_switch);
% 
% psnr = metrix_psnr(C_V,C_V_O);
% fprintf('psnr = %f\n',psnr);
% 
% ssim = metrix_ssim(C_V,C_V_O);
% fprintf('ssim = %f\n',ssim);
% 
% imwrite(C_V, ['ExAbBreakResult',num2str(i),num2str(j),num2str(k),num2str(l), sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
% 
%             end
%         end
%     end
% end

% 
% is_dibr_do_refinement = true;
% LoadKendo;
% frame = 50;
% for i = 0 : 1
%     for j = 0 : 1
%         for k = 0 : 1
%             for l = 0 : 1
%                 ablation_switch = [i j k l];
%                 is_dibr_do_refinement = i;
%                 LoadKendoData;
% 
% [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), false, ablation_switch);
% 
% psnr = metrix_psnr(C_V,C_V_O);
% fprintf('psnr = %f\n',psnr);
% 
% ssim = metrix_ssim(C_V,C_V_O);
% fprintf('ssim = %f\n',ssim);
% 
% imwrite(C_V, ['ExAbKendoResult',num2str(i),num2str(j),num2str(k),num2str(l), sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
% 
%             end
%         end
%     end
% end
% 
% 
% is_dibr_do_refinement = true;
% LoadPoznanStreet;
% frame = 50;
% for i = 0 : 1
%     for j = 0 : 1
%         for k = 0 : 1
%             for l = 0 : 1
%                 ablation_switch = [i j k l];
%                 is_dibr_do_refinement = i;
%                 LoadPoznanStreetData;
% 
% [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, D_L_O, D_R_O, K_L, K_R, K_V, Rt_L, Rt_R, Rt_V, Znear / abs(Znear), false, ablation_switch);
% 
% psnr = metrix_psnr(C_V,C_V_O);
% fprintf('psnr = %f\n',psnr);
% 
% ssim = metrix_ssim(C_V,C_V_O);
% fprintf('ssim = %f\n',ssim);
% 
% imwrite(C_V, ['ExAbStreetResult',num2str(i),num2str(j),num2str(k),num2str(l), sprintf(' psnr %f ssim %f',psnr, ssim) , '.png']);
% 
%             end
%         end
%     end
% end
% 


