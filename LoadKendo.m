% is_dibr_do_refinement = false;

pics_dir = 'Kendo/';
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

Znear = 448.251214;
Zfar = 11206.280350;

K_L = [2241.25607 0.0 701.5;
       0.0 2241.25607 514.5;
       0.0 0.0 1.0    ];
K_R = [2241.25607 0.0 701.5;
       0.0 2241.25607 514.5;
       0.0 0.0 1.0    ];
K_V = [2241.25607 0.0 701.5;
       0.0 2241.25607 514.5;
       0.0 0.0 1.0    ];
Rt_L = ([eye(3), [25 0 0]']);
Rt_R = ([eye(3), [5 0 0]']);
Rt_V = ([eye(3), [15 0 0]']);
