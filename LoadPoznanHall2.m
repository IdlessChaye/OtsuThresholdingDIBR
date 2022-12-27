% is_dibr_do_refinement = false;

pics_dir = 'PoznanHall2/';
if is_dibr_do_refinement == false
    depthColorRefinement(pics_dir); % 颜色图和深度图滤波 Color Depth Refinement
end

refined_dir_name = 'DepthColorRefinement/';
color_dir_name = 'Color/';
depth_dir_name = 'Depth/';
prc_dir_name = [pics_dir,refined_dir_name,color_dir_name];
prd_dir_name = [pics_dir,refined_dir_name,depth_dir_name];
pc_dir_name = [pics_dir, color_dir_name];
pd_dir_name = [pics_dir, depth_dir_name];

Znear = -23.394160;
Zfar = -172.531931;

K_L = [1732.875727 0.0           943.231169
        0.0           1729.908923   548.845040
        0.0           0.0           1.0];
K_R = [1732.875727 0.0           943.231169
        0.0           1729.908923   548.845040
        0.0           0.0           1.0];
K_V = [1732.875727 0.0           943.231169
        0.0           1729.908923   548.845040
        0.0           0.0           1.0];
Rt_L = ([eye(3), [11.151163 0 0]']);
Rt_R = ([eye(3), [7.965116 0 0]']);
Rt_V = ([eye(3), [9.5581395 0 0]']);
