%frame = 1;

Znear_frame_L = Znear_frame_Ls(frame);
Zfar_frame_L = Zfar_frame_Ls(frame);
Znear_frame_R = Znear_frame_Rs(frame);
Zfar_frame_R = Zfar_frame_Rs(frame);
Znear = (Znear_frame_L + Znear_frame_R) / 2;
Zfar = (Zfar_frame_L + Zfar_frame_R) / 2;

frame_num = num2str(frame);
C_L_O_path = [prc_dir_name,'cam1_.yuv',frame_num,'.png'];
C_R_O_path = [prc_dir_name,'cam9_.yuv',frame_num,'.png'];
C_V_O_path = [pc_dir_name,'cam5_.yuv',frame_num,'.png'];
D_L_O_path = [prd_dir_name,'cam1_.yuv',frame_num,'.png'];
D_R_O_path = [prd_dir_name,'cam9_.yuv',frame_num,'.png'];

C_L_O = double(imread(C_L_O_path));
C_R_O = double(imread(C_R_O_path));
C_V_O = imread(C_V_O_path);
D_L_O = getDepthMap(imread(D_L_O_path),Znear_frame_L, Zfar_frame_L);
D_R_O = getDepthMap(imread(D_R_O_path),Znear_frame_R, Zfar_frame_R);
