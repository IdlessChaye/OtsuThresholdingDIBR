function depthColorRefinement(pics_dir)
%DepthColorRefinement
% 预处理数据集的颜色图片和深度图片
% 在数据集文件夹中创建DepthColorRefinement文件夹
% 如果文件夹已经存在，则跳过处理
% 要求数据集中颜色和深度图片分别建立文件夹，并排序一一对应

    color_dir_name = 'Color/';
    depth_dir_name = 'Depth/';
    refined_dir_name = 'DepthColorRefinement/';
    refined_dir = [pics_dir, refined_dir_name];
    
    if exist(refined_dir,'dir')
        return;
    end
    
    mkdir(refined_dir);
    refined_color_dir = [refined_dir, color_dir_name];
    refined_depth_dir = [refined_dir, depth_dir_name];
    mkdir(refined_color_dir);
    mkdir(refined_depth_dir);
    
    DIR_color = dir([pics_dir,color_dir_name]);
    DIR_depth = dir([pics_dir,depth_dir_name]);
    if size(DIR_color, 1) ~= size(DIR_depth, 1)
        error( 'Count of Color and Depth maps is not same.' );
    end
    
    count = size(DIR_color, 1);
    for i = 1:count
        c_dir = DIR_color(i,1);
        d_dir = DIR_depth(i,1);
        
        c_is_dir = c_dir.isdir;
        d_is_dir = d_dir.isdir;
        if c_is_dir || d_is_dir
            continue;
        end
        
        c_name = c_dir.name;
        d_name = d_dir.name;
        C_O = double(imread([pics_dir,color_dir_name,c_name]));
        D_O = double(imread([pics_dir,depth_dir_name,d_name]));
        [D, C] = getDepthColorRefinement(D_O, C_O);
        
        D = uint8(cat(3, D, D, D));
        C = uint8(C);
        imwrite(C,[refined_color_dir, c_name]);
        imwrite(D,[refined_depth_dir, d_name]);
    end
end