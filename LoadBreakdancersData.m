% frame = 0;
% cam_L = 3;
% cam_R = 5;
% cam_V = 4;
% is_dibr_do_refinement = false;

frame_num = num2str(frame,'%03d');
if is_dibr_do_refinement == false
    C_L_O_path = [prc_dir_name,'color-cam',num2str(cam_L),'-f',frame_num,'.jpg'];
    C_R_O_path = [prc_dir_name,'color-cam',num2str(cam_R),'-f',frame_num,'.jpg'];
    C_V_O_path = [pc_dir_name,'color-cam',num2str(cam_V),'-f',frame_num,'.jpg'];
    D_L_O_path = [prd_dir_name,'depth-cam',num2str(cam_L),'-f',frame_num,'.png'];
    D_R_O_path = [prd_dir_name,'depth-cam',num2str(cam_R),'-f',frame_num,'.png'];
else
    C_L_O_path = [pc_dir_name,'color-cam',num2str(cam_L),'-f',frame_num,'.jpg'];
    C_R_O_path = [pc_dir_name,'color-cam',num2str(cam_R),'-f',frame_num,'.jpg'];
    C_V_O_path = [pc_dir_name,'color-cam',num2str(cam_V),'-f',frame_num,'.jpg'];
    D_L_O_path = [pd_dir_name,'depth-cam',num2str(cam_L),'-f',frame_num,'.png'];
    D_R_O_path = [pd_dir_name,'depth-cam',num2str(cam_R),'-f',frame_num,'.png'];
end

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