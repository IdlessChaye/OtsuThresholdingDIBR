% is_dibr_do_refinement = false;

pics_dir = 'PoznanStreet/';
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

Znear = -34.506386;
Zfar = -2760.510889;

K_L = [1732.875727	0.000000	943.231169
        0.000000	1729.908923	548.845040
        0.000000	0.000000	1.000000  ];
K_R = [1732.875727	0.000000	943.231169
        0.000000	1729.908923	548.845040
        0.000000	0.000000	1.000000 ];
K_V = [1732.875727	0.000000	943.231169
        0.000000	1729.908923	548.845040
        0.000000	0.000000	1.000000 ];
Rt_L = ([eye(3), [7.965116 0 0]']);
Rt_R = ([eye(3), [4.779070 0 0]']);
Rt_V = ([eye(3), [6.3721 0 0]']);
