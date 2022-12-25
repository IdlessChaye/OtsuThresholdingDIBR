
% frame = 1;

frame_num = num2str(frame);
C_L_O_path = [prc_dir_name,'cam5_.yuv',frame_num,'.png'];
C_R_O_path = [prc_dir_name,'cam7_.yuv',frame_num,'.png'];
C_V_O_path = [pc_dir_name,'cam6_.yuv',frame_num,'.png'];
D_L_O_path = [prd_dir_name,'cam5_.yuv',frame_num,'.png'];
D_R_O_path = [prd_dir_name,'cam7_.yuv',frame_num,'.png'];

C_L_O = double(imread(C_L_O_path));
C_R_O = double(imread(C_R_O_path));
C_V_O = imread(C_V_O_path);
D_L_O = getDepthMap(imread(D_L_O_path),Znear, Zfar);
D_R_O = getDepthMap(imread(D_R_O_path),Znear, Zfar);
