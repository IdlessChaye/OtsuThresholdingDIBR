function [C_V] = dibrAblation(layer_number, C_L_O, C_R_O, Z_L_O, Z_R_O, K_L_O, K_R_O, K_V_O, Rt_L_O, Rt_R_O, Rt_V_O, z_sign, is_dibr_do_refinement, ablation_switch)
%     DIBR
%
%     is_dibr_do_refinement = true; % if not pre-treatment depth map and color map, set true
%     layer_number = 3; % 分层数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('---------------------');

    t1 = clock; % dibr

    is_show_image = false; % for debug
    
    
    has_refinement = true;
    has_colorCorrection = true;
    has_layered = true;
    has_inpainting = true;
    if ablation_switch(1) == true
        has_refinement = false;
    end
    if ablation_switch(2) == true
        has_colorCorrection = false;
    end
    if ablation_switch(3) == true
        has_layered = false;
    end
    if ablation_switch(4) == true
        has_inpainting = false;
    end
    
    is_no_layered = layer_number == 1 || has_layered == false; % hack
    if is_no_layered
        layer_number = 2;
    end
    
    %% 算法参数
    
    [H,W,~] = size(C_L_O);
    
	%% 深度细化 像素矫正
    
    tic; % refinement
    
    if has_refinement == true && is_dibr_do_refinement == true
        [Z_L_O, C_L_O] = getDepthColorRefinement(Z_L_O, C_L_O);
        [Z_R_O, C_R_O] = getDepthColorRefinement(Z_R_O, C_R_O);
    end
    
    disp('0.1 深度颜色细化:');
    toc; % refinement
    
    %% 亮度矫正
    
    tic; % HSV
    
    if has_colorCorrection == true
        % 亮度矫正 消除鬼影 提升psnr
        [C_L_O,C_R_O] = getColorCorrected(C_L_O,C_R_O);
    end

    disp('1. 颜色校正:');
    toc; % HSV

    %% 获取双路原视点的深度分层阈值 分层，但效果不明显，只是理论上可以将前后景的物体分层

    tic; % layered
    
    t7 = clock; % 分层三维映射
    
    layer_thresh_L = multithresh(Z_L_O, layer_number - 1);
    layer_thresh_R = multithresh(Z_R_O, layer_number - 1);

    %% 计算新视点的深度分层阈值

    layer_thresh_mean = (layer_thresh_L + layer_thresh_R) / 2;

    %% 双路前向映射，并按照新视点的深度分层阈值来分层

    Z_V_Ls = cell([1, layer_number]); % 新视点处左路映射来的分层深度
    Z_V_Rs = cell([1, layer_number]); % 新视点处右路映射来的分层深度
    C_V_Ls = cell([1, layer_number]); % 新视点处左路映射来的分层颜色
    C_V_Rs = cell([1, layer_number]); % 新视点处右路映射来的分层颜色

    for i = 1 : layer_number
        Z_V_Ls{i} = zeros([H,W,1]);
        Z_V_Rs{i} = zeros([H,W,1]);
        C_V_Ls{i} = zeros([H,W,3]);
        C_V_Rs{i} = zeros([H,W,3]);
    end

    v_points_L = getWarping3DPoints(K_L_O, Rt_L_O, Z_L_O); % 左路索引点位映射到了世界空间
    [Z_L, uv_L] = getWarpingZMapUVPoints(v_points_L, K_V_O, Rt_V_O, H); % 左路索引点位映射到了新视点

    v_points_R = getWarping3DPoints(K_R_O, Rt_R_O, Z_R_O);
    [Z_R, uv_R] = getWarpingZMapUVPoints(v_points_R, K_V_O, Rt_V_O, H);

    Z_Ls = cell([1, layer_number]); % 索引是原视点的，存的新视点的深度
    Z_Rs = cell([1, layer_number]);
    uv_Ls = cell([1, layer_number]); % 索引是原视点的，存的新视点的uv
    uv_Rs = cell([1, layer_number]);
    C_Ls = cell([1, layer_number]); % 索引是原视点的，存的原视点的颜色
    C_Rs = cell([1, layer_number]);
    C_L_r = C_L_O(:,:,1);
    C_L_g = C_L_O(:,:,2);
    C_L_b = C_L_O(:,:,3);
    C_R_r = C_R_O(:,:,1);
    C_R_g = C_R_O(:,:,2);
    C_R_b = C_R_O(:,:,3);
    C_L = [C_L_r(:)';C_L_g(:)';C_L_b(:)'];
    C_R = [C_R_r(:)';C_R_g(:)';C_R_b(:)'];

    Z_thresh = layer_thresh_mean(1); % 分层深度和颜色

    index_Z_layered_L = find(Z_L < Z_thresh);
    Z_Ls{1} = Z_L(index_Z_layered_L);
    uv_Ls{1} = uint32(uv_L(:, index_Z_layered_L));
    C_Ls{1} = C_L(:, index_Z_layered_L);

    index_Z_layered_R = find(Z_R < Z_thresh);
    Z_Rs{1} = Z_R(index_Z_layered_R);
    uv_Rs{1} = uint32(uv_R(:, index_Z_layered_R));
    C_Rs{1} = C_R(:, index_Z_layered_R);

    for i = 1 : layer_number - 2
        Z_thresh_low = layer_thresh_mean(i);
        Z_thresh_high = layer_thresh_mean(i + 1);

        index_Z_layered_L = find(Z_L >= Z_thresh_low & Z_L < Z_thresh_high);
        Z_Ls{i + 1} = Z_L(index_Z_layered_L);
        uv_Ls{i + 1} = uint32(uv_L(:, index_Z_layered_L));
        C_Ls{i + 1} = C_L(:, index_Z_layered_L);

        index_Z_layered_R = find(Z_R >= Z_thresh_low & Z_R < Z_thresh_high);
        Z_Rs{i + 1} = Z_R(index_Z_layered_R);
        uv_Rs{i + 1} = uint32(uv_R(:, index_Z_layered_R));
        C_Rs{i + 1} = C_R(:, index_Z_layered_R);
    end

    Z_thresh = layer_thresh_mean(layer_number - 1);

    index_Z_layered_L = find(Z_L >= Z_thresh);
    Z_Ls{layer_number} = Z_L(index_Z_layered_L);
    uv_Ls{layer_number} = uint32(uv_L(:, index_Z_layered_L));
    C_Ls{layer_number} = C_L(:, index_Z_layered_L);

    index_Z_layered_R = find(Z_R >= Z_thresh);
    Z_Rs{layer_number} = Z_R(index_Z_layered_R);
    uv_Rs{layer_number} = uint32(uv_R(:, index_Z_layered_R));
    C_Rs{layer_number} = C_R(:, index_Z_layered_R);

    for i = 1 : layer_number % 索引点位安置到新视点图像中
        zl = Z_Ls{i};
        zr = Z_Rs{i};
        uvl = uv_Ls{i};
        uvr = uv_Rs{i};
        cl = C_Ls{i};
        cr = C_Rs{i};

        size_L = size(zl);
        size_L = size_L(2);
        for j = 1 : size_L
            u = uvl(1,j);
            v = uvl(2,j);
            if u <= 0 || u > W || v <= 0 || v > H
                continue;
            end

            Z = zl(j);
            C = cl(:, j);
            if Z * z_sign <= 0
                continue;
            end

            if Z_V_Ls{i}(v,u,:) == 0
                Z_V_Ls{i}(v,u,:) = Z;
                C_V_Ls{i}(v,u,:) = C;
            else
                if Z_V_Ls{i}(v,u,:) * z_sign > Z * z_sign 
                    Z_V_Ls{i}(v,u,:) = Z;
                    C_V_Ls{i}(v,u,:) = C;
                end
            end
        end

        size_R = size(zr);
        size_R = size_R(2);
        for j = 1 : size_R
            u = uvr(1,j);
            v = uvr(2,j);
            if u <= 0 || u > W || v <= 0 || v > H
                continue;
            end

            Z = zr(j);
            C = cr(:, j);
            if Z * z_sign <= 0
                continue;
            end

            if Z_V_Rs{i}(v,u,:) == 0
                Z_V_Rs{i}(v,u,:) = Z;
                C_V_Rs{i}(v,u,:) = C;
            else
                if Z_V_Rs{i}(v,u,:) * z_sign  > Z * z_sign 
                    Z_V_Rs{i}(v,u,:) = Z;
                    C_V_Rs{i}(v,u,:) = C;
                end
            end
        end
    end

    if is_show_image
        % for k = 1 : layer_number
        %     figure;imshow(uint8(Z_V_Ls{k}));
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_V_Ls{k}))); title(['左路',num2str(k) , '层映射后颜色']); drawnow;
        end
        % for k = 1 : layer_number
        %     figure;imshow(uint8(Z_V_Rs{k}));
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_V_Rs{k}))); title(['右路',num2str(k) , '层映射后颜色']); drawnow;
        end

        show3Dpoints2image(v_points_L,Rt_V_O ,K_V_O ,linear2sRGB(C_L_O) ,H,W);
        show3Dpoints2image(v_points_R,Rt_V_O ,K_V_O ,linear2sRGB(C_R_O) ,H,W);
    end
    
    t8 = clock; % 分层三维映射
    fprintf('2.1 分层三维映射:\n时间已过 %f 秒。\n', etime(t8,t7));

    %% 分层融合得到各层的深度图和颜色图

    t9 = clock; % 双路融合
    
    [weight_dis_L, weight_dis_R] = getWeightViewpointDis(Rt_V_O, Rt_L_O, Rt_R_O); % 视点位移权重 融合算法直接引用其他论文
    Z_Vs = cell([1, layer_number]); 
    C_Vs = cell([1, layer_number]); 
    
    for i = 1 : layer_number
        Z_Vs{i} = zeros([H,W,1]);
        C_Vs{i} = zeros([H,W,3]);
    end

    for i = 1 : layer_number
        Z_V_L = Z_V_Ls{i};
        Z_V_R = Z_V_Rs{i};
        C_V_L = C_V_Ls{i};
        C_V_R = C_V_Rs{i};
        % 双路融合
        for u = 1 : W
            for v = 1 : H
                zvl = Z_V_L(v,u,:);
                zvr = Z_V_R(v,u,:);
                cvl = C_V_L(v,u,:);
                cvr = C_V_R(v,u,:);
                if zvl * z_sign <= 0 && zvr * z_sign <= 0
                    continue;
                elseif zvl * z_sign > 0 && zvr * z_sign <= 0
                    Z_Vs{i}(v,u,:) = zvl;
                    C_Vs{i}(v,u,:) = cvl;
                elseif zvl * z_sign <= 0 && zvr * z_sign > 0
                    Z_Vs{i}(v,u,:) = zvr;
                    C_Vs{i}(v,u,:) = cvr;
                elseif zvl * z_sign > 0 && zvr * z_sign > 0
                    sum_cvr = sum(cvr);
                    sum_cvl = sum(cvl);
                    if sum_cvr ~= 0 && sum_cvl ~= 0
                        Z_Vs{i}(v,u,:) = weight_dis_R * zvr + weight_dis_L * zvl;
                        C_Vs{i}(v,u,:) = weight_dis_R * cvr + weight_dis_L * cvl;
                    elseif sum_cvr ~= 0
                        Z_Vs{i}(v,u,:) = zvr;
                        C_Vs{i}(v,u,:) = cvr;
                    elseif sum_cvl ~= 0
                        Z_Vs{i}(v,u,:) = zvl;
                        C_Vs{i}(v,u,:) = cvl;
                    end
                end
            end
        end
    end

    if is_show_image
        % for k = 1 : layer_number
        %     figure;imshow(Z_Vs{k});
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_Vs{k}))); title([num2str(k),'层融合']); drawnow;
        end
    end

    t10 = clock; % 双路融合
    fprintf('2.2 双路融合:\n时间已过 %f 秒。\n', etime(t10,t9));
    
    %% 对各层融合得到的深度图和颜色图分别进行层内筛选中值滤波

    t5 = clock; % select mean
    
    Z_V_inpaints = cell([1, layer_number]); 
    C_V_inpaints = cell([1, layer_number]); 

    % 筛选中值滤波
    w_select_radius = 5;
    w_calc_radius = 2;
    for i = 1 : layer_number
        if is_no_layered == false
            [C_V_inpaints{i}, Z_V_inpaints{i}] = getColorSwitchingDepthMedianFilter(C_Vs{i}, Z_Vs{i}, w_select_radius, w_calc_radius);
%             [C_V_inpaints{i}, Z_V_inpaints{i}] = getColorSwitchingDepthMeanFilter(C_Vs{i}, Z_Vs{i}, w_select_radius, w_calc_radius);
        else
            C_V_inpaints{i} = C_Vs{i};
            Z_V_inpaints{i} = Z_Vs{i};     
        end
    end

    if is_show_image
        % for k = 1 : layer_number
        %     figure;imshow(Z_V_inpaints{k});
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_V_inpaints{k}))); title([num2str(k),'层筛选中值滤波']); drawnow;
        end
    end

    t6 = clock; % 筛选中值滤波
    fprintf('2.3 筛选中值滤波:\n时间已过 %f 秒。\n', etime(t6,t5));
    
    %% 叠加分层得到新视点图

    t11 = clock; % 叠加分层
    
    Z_V_overlay = zeros(H, W, 1);
    C_V_overlay = zeros(H, W, 3);

    for i = 1 : layer_number
        for u = 1 : W
            for v = 1 : H
                z = Z_V_inpaints{i}(v,u,1);
                if z == 0
                    continue;
                end
                if Z_V_overlay(v, u, 1) == 0
                    Z_V_overlay(v,u,1) = z;
                    C_V_overlay(v,u,:) = C_V_inpaints{i}(v,u,:);
                end
            end
        end
    end

    if is_show_image
        figure;imshow(Z_V_overlay); title('叠加深度图'); drawnow;
        figure;imshow(uint8(linear2sRGB(C_V_overlay))); title('叠加颜色图'); drawnow;
    end
    
    t12 = clock; % 叠加分层
    fprintf('2.4 叠加分层:\n时间已过 %f 秒。\n', etime(t12,t11));
    
    disp('2. 总分层算法:');
    toc; % layered

    %% 对新视点的颜色图进行中值滤波和图像填补

    t3 = clock; % 总图像填补
    
    if has_inpainting == true
        
%         tic; % 中值滤波
%         w_radius = 2;
%         C_V_inpaint_median = cat(3,medfilt2(C_V_overlay(:,:,1),[2 * w_radius + 1, 2 * w_radius + 1]),medfilt2(C_V_overlay(:,:,2),[2 * w_radius + 1, 2 * w_radius + 1]),medfilt2(C_V_overlay(:,:,3),[2 * w_radius + 1, 2 * w_radius + 1]));
%         Z_V_inpaint_median = medfilt2(Z_V_overlay(:,:,1),[2 * w_radius + 1, 2 * w_radius + 1]);
        C_V_inpaint_median = C_V_overlay;
        Z_V_inpaint_median = Z_V_overlay;
    
%         if is_show_image
% %             figure;imshow(Z_V_inpaint_median); title('叠加中值滤波深度图'); drawnow;
%             figure;imshow(uint8(linear2sRGB(C_V_inpaint_median))); title('叠加中值滤波颜色图'); drawnow;
%         end
% 
%         disp('3.1 中值滤波:');
%         toc; % median inpainting

        tic; % hole inpainting

        % 图像填补
        % 如果点不在视点边缘，假设造成空洞的原因是因为前景遮挡，根据背景图像进行图像填补
        % 如果点在视点边缘，假设造成空洞的原因是因为视点边缘信息缺失，根据叠加图像进行图像填补

        if is_no_layered == false
            Z_V_background = zeros(H, W, 1);
            C_V_background = zeros(H, W, 3);
            for i = 2 : layer_number
                for u = 1 : W
                    for v = 1 : H
                        z = Z_V_inpaints{i}(v,u,1);
                        if z == 0
                            continue;
                        end
                        if Z_V_background(v, u, 1) == 0
                            Z_V_background(v,u,1) = z;
                            C_V_background(v,u,:) = C_V_inpaints{i}(v,u,:);
                        end
                    end
                end
            end

            Z_V_inpaint_hole = getDepthPixelInpaintHole2(Z_V_inpaint_median, Z_V_background);
            C_V_inpaint_hole = getColorPixelInpaintHole2(C_V_inpaint_median, C_V_background);
        else
            Z_V_inpaint_hole = getDepthPixelInpaintHole3(Z_V_inpaint_median);
            C_V_inpaint_hole = getColorPixelInpaintHole3(C_V_inpaint_median);
        end

        if is_show_image
            figure;imshow(uint8(Z_V_inpaint_hole)); title('叠加图像填补深度图'); drawnow;
            figure;imshow(uint8(linear2sRGB(C_V_inpaint_hole))); title('叠加图像填补图'); drawnow;
        end
        
        disp('3.2 图像填补:');
        toc; % hole inpainting
    else
        Z_V_inpaint_hole = Z_V_overlay;
        C_V_inpaint_hole = C_V_overlay;
    end
    
    t4 = clock; % inpainting
    fprintf('3. 总图像填补:\n时间已过 %f 秒。\n', etime(t4,t3));
    
    %% Edge Blur
    
    tic; % edge fuse
    
    Z_edge_dilate = imdilate(edge(Z_V_inpaint_hole, 'canny'), strel('square', 2));
    C_V_edge_fuse = getColorPixelMeanByEdge(C_V_inpaint_hole, Z_edge_dilate, 2);
    
    if is_show_image
        figure;imshow(uint8(linear2sRGB(C_V_edge_fuse))); title('填补边缘模糊图'); drawnow;
    end
    
    disp('4. 边缘模糊:');
    toc; % Edge Blur
    
    %% output
    
%     Z_V = double(Z_V_inpaint_hole);
    C_V = uint8(C_V_edge_fuse);
    
    t2 = clock; % dibr
    fprintf('5. 总DIBR:\n时间已过 %f 秒。\n', etime(t2,t1));
    
    disp('---------------------');
end