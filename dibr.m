function [C_V] = dibr(layer_number, Znear, Zfar, C_L_O, C_R_O, Z_L_O, Z_R_O, K_L_O, K_R_O, K_V_O, Rt_L_O, Rt_R_O, Rt_V_O)
%     DIBR
%
%     layer_number = 3; % �ֲ���
%     Znear = 0; % �ӵ�������룬�����ݼ��ļ�������
%     Zfar = 0; % �ӵ���Զ���룬�����ݼ��ļ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    is_show_image = false; % for debug
    is_no_layered = layer_number == 1;
    if is_no_layered
        layer_number = 2;
    end

    %% �㷨����

%     factor_attenuation = 6; % �ںϷ��̣�ָ��˥��ϵ��
%     ratio_max_delta_dis = 1; % �ںϷ��̣�����Ӧ�����Ȳ���ֵ���������Űٷֱ�
    
    [H,W,~] = size(C_L_O);

    %% ���Ƚ��� % + gamma����
    
    % ���Ƚ��� ������Ӱ ����psnr
    hsv_L_O = rgb2hsv(C_L_O);
    hsv_R_O = rgb2hsv(C_R_O);
    light_L_O = sum(sum(hsv_L_O(:,:,3))) / H / W;
    light_R_O = sum(sum(hsv_R_O(:,:,3))) / H / W;
    hsv_L_O(:,:,3) = hsv_L_O(:,:,3) ./ light_L_O .* light_R_O;
    C_L_O = hsv2rgb(hsv_L_O);

%     % gamma����
%     C_L_O = sRGB2linear(C_L_O);
%     C_R_O = sRGB2linear(C_R_O);

    %% ��ȡ˫·ԭ�ӵ����ȷֲ���ֵ �ֲ㣬��Ч�������ԣ�ֻ�������Ͽ��Խ�ǰ�󾰵�����ֲ�

    layer_thresh_L = multithresh(Z_L_O, layer_number - 1);
    layer_thresh_R = multithresh(Z_R_O, layer_number - 1);

    %% �������ӵ����ȷֲ���ֵ

    layer_thresh_mean = (layer_thresh_L + layer_thresh_R) / 2;

    %% ˫·ǰ��ӳ�䣬���������ӵ����ȷֲ���ֵ���ֲ�

    Z_V_Ls = cell([1, layer_number]); % ���ӵ㴦��·ӳ�����ķֲ����
    Z_V_Rs = cell([1, layer_number]); % ���ӵ㴦��·ӳ�����ķֲ����
    C_V_Ls = cell([1, layer_number]); % ���ӵ㴦��·ӳ�����ķֲ���ɫ
    C_V_Rs = cell([1, layer_number]); % ���ӵ㴦��·ӳ�����ķֲ���ɫ

    for i = 1 : layer_number
        Z_V_Ls{i} = zeros([H,W,1]);
        Z_V_Rs{i} = zeros([H,W,1]);
        C_V_Ls{i} = zeros([H,W,3]);
        C_V_Rs{i} = zeros([H,W,3]);
    end

    v_points_L = getWarping3DPoints(K_L_O, Rt_L_O, Z_L_O); % ��·������λӳ�䵽������ռ�
    [Z_L, uv_L] = getWarpingZMapUVPoints(v_points_L, K_V_O, Rt_V_O, H); % ��·������λӳ�䵽�����ӵ�

    v_points_R = getWarping3DPoints(K_R_O, Rt_R_O, Z_R_O);
    [Z_R, uv_R] = getWarpingZMapUVPoints(v_points_R, K_V_O, Rt_V_O, H);

    Z_Ls = cell([1, layer_number]); % ������ԭ�ӵ�ģ�������ӵ�����
    Z_Rs = cell([1, layer_number]);
    uv_Ls = cell([1, layer_number]); % ������ԭ�ӵ�ģ�������ӵ��uv
    uv_Rs = cell([1, layer_number]);
    C_Ls = cell([1, layer_number]); % ������ԭ�ӵ�ģ����ԭ�ӵ����ɫ
    C_Rs = cell([1, layer_number]);
    C_L_r = C_L_O(:,:,1);
    C_L_g = C_L_O(:,:,2);
    C_L_b = C_L_O(:,:,3);
    C_R_r = C_R_O(:,:,1);
    C_R_g = C_R_O(:,:,2);
    C_R_b = C_R_O(:,:,3);
    C_L = [C_L_r(:)';C_L_g(:)';C_L_b(:)'];
    C_R = [C_R_r(:)';C_R_g(:)';C_R_b(:)'];

    Z_thresh = layer_thresh_mean(1); % �ֲ���Ⱥ���ɫ

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

    for i = 1 : layer_number % ������λ���õ����ӵ�ͼ����
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
            if Z <= 0
                continue;
            end

            if Z_V_Ls{i}(v,u,:) == 0
                Z_V_Ls{i}(v,u,:) = Z;
                C_V_Ls{i}(v,u,:) = C;
            else
                if Z_V_Ls{i}(v,u,:) > Z
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
            if Z <= 0
                continue;
            end

            if Z_V_Rs{i}(v,u,:) == 0
                Z_V_Rs{i}(v,u,:) = Z;
                C_V_Rs{i}(v,u,:) = C;
            else
                if Z_V_Rs{i}(v,u,:) > Z
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
            figure;imshow(uint8(linear2sRGB(C_V_Ls{k})));
        end
        % for k = 1 : layer_number
        %     figure;imshow(uint8(Z_V_Rs{k}));
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_V_Rs{k})));
        end

        show3Dpoints2image(v_points_L,Rt_V_O ,K_V_O ,linear2sRGB(C_L_O) ,H,W);
        show3Dpoints2image(v_points_R,Rt_V_O ,K_V_O ,linear2sRGB(C_R_O) ,H,W);
    end

    %% �ֲ��ںϵõ���������ͼ����ɫͼ

    layer_delta_dists = zeros([1, layer_number]); % ����Ӧͼ���ں��㷨
    layer_delta_dists(1) = layer_thresh_mean(1) - Znear;
    layer_delta_dists(layer_number) = Zfar - layer_thresh_mean(layer_number - 1);
    for i = 1 : layer_number - 2
        layer_delta_dists(i + 1) = layer_thresh_mean(i + 1) - layer_thresh_mean(i);
    end
    [weight_dis_L, weight_dis_R] = getWeightViewpointDis(Rt_V_O, Rt_L_O, Rt_R_O); % �ӵ�λ��Ȩ�� �ں��㷨ֱ��������������
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
%         layer_delta_dist = layer_delta_dists(i) * ratio_max_delta_dis;
        % ˫·�ں�
        for u = 1 : W
            for v = 1 : H
                zvl = Z_V_L(v,u,:);
                zvr = Z_V_R(v,u,:);
                cvl = C_V_L(v,u,:);
                cvr = C_V_R(v,u,:);
                if zvl <= 0 && zvr <= 0
                    continue;
                elseif zvl > 0 && zvr == 0
                    Z_Vs{i}(v,u,:) = zvl;
                    C_Vs{i}(v,u,:) = cvl;
                elseif zvl == 0 && zvr > 0
                    Z_Vs{i}(v,u,:) = zvr;
                    C_Vs{i}(v,u,:) = cvr;
                elseif zvl > 0 && zvr > 0
%                     delta_z = abs(zvl - zvr); % �������Ȩ��
%                     weight_far_dis = 0.5 * exp(-delta_z * factor_attenuation / layer_delta_dist);
%                     weight_near_dis = 1 - weight_far_dis;
%                     if zvl < zvr
%                         weight_n = weight_dis_L * weight_near_dis; % ����Ȩ��=�ӵ�λ��Ȩ��*�������Ȩ��
%                         weight_f = weight_dis_R * weight_far_dis;
%                         weight_near = weight_n / (weight_n + weight_f);
%                         weight_far = weight_f / (weight_n + weight_f);
%                         Z_Vs{i}(v,u,:) = zvl;
%                         C_Vs{i}(v,u,:) = weight_near * cvl + weight_far * cvr;
%                     elseif zvl >= zvr
%                         weight_n = weight_dis_R * weight_near_dis;
%                         weight_f = weight_dis_L * weight_far_dis;
%                         weight_near = weight_n / (weight_n + weight_f);
%                         weight_far = weight_f / (weight_n + weight_f);
%                         Z_Vs{i}(v,u,:) = zvr;
%                         C_Vs{i}(v,u,:) = weight_near * cvr + weight_far * cvl;
%                     end
                    Z_Vs{i}(v,u,:) = weight_dis_R * zvr + weight_dis_L * zvl;
                    C_Vs{i}(v,u,:) = weight_dis_R * cvr + weight_dis_L * cvl;
                end
            end
        end
    end

    if is_show_image
        % for k = 1 : layer_number
        %     figure;imshow(Z_Vs{k});
        % end
        for k = 1 : layer_number
            figure;imshow(uint8(linear2sRGB(C_Vs{k}))); title('�����ں�'); drawnow;
        end
    end

    %% �Ը����ںϵõ������ͼ����ɫͼ�ֱ���в�����ֵ�˲�

    Z_V_inpaints = cell([1, layer_number]); 
    C_V_inpaints = cell([1, layer_number]); 

    % ���������ֵ�˲� ����Ҫ���αӰ�����Լ����ָ�Ƶ��ɫ�ĸ�������
    w_select_radius = 5;
    w_calc_radius = 2;
    for i = 1 : layer_number
        if is_no_layered == false
            [C_V_inpaints{i}, Z_V_inpaints{i}] = getColorSwitchingDepthMedianFilter(C_Vs{i}, Z_Vs{i}, w_select_radius, w_calc_radius);
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
            figure;imshow(uint8(linear2sRGB(C_V_inpaints{k}))); title('������ֵ�˲�'); drawnow;
        end
    end

    %% �ֲ���ӵõ����ӵ��ͼ

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
        figure;imshow(Z_V_overlay);
        figure;imshow(uint8(linear2sRGB(C_V_overlay)));
    end

    %% �����ӵ����ɫͼ������ֵ�˲���ͼ���

    % ��ֵ�˲�
    w_radius = 2;
%     [C_V_inpaint_median, Z_V_inpaint_median] = getColorDepthMedianFilter(C_V_overlay, Z_V_overlay, w_radius);
    C_V_inpaint_median = cat(3,medfilt2(C_V_overlay(:,:,1),[2 * w_radius + 1, 2 * w_radius + 1]),medfilt2(C_V_overlay(:,:,2),[2 * w_radius + 1, 2 * w_radius + 1]),medfilt2(C_V_overlay(:,:,3),[2 * w_radius + 1, 2 * w_radius + 1]));
    Z_V_inpaint_median = medfilt2(Z_V_overlay(:,:,1),[2 * w_radius + 1, 2 * w_radius + 1]);

    if is_show_image
        % figure;imshow(Z_V_inpaint_median);
        figure;imshow(uint8(linear2sRGB(C_V_inpaint_median)));
    end

    
    % ͼ���
    C_V_inpaint_hole = C_V_inpaint_median;

    % ����ͼ��
    Z_V_background = zeros(H, W, 1);
    C_V_background = zeros(H, W, 3);
    for i = 2 : layer_number % �ų�ǰ��
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

    if is_show_image
        % figure;imshow(Z_V_background);
        figure;imshow(uint8(linear2sRGB(C_V_background)));
    end
    
    % ����㲻���ӵ��Ե��������ɿն���ԭ������Ϊǰ���ڵ������ݱ���ͼ�����ͼ���
    % ��������ӵ��Ե��������ɿն���ԭ������Ϊ�ӵ��Ե��Ϣȱʧ�����ݵ���ͼ�����ͼ���
    for i = 1 : H
        for j = 1 : W
            z = Z_V_inpaint_median(i,j);
            if z ~= 0
                continue;
            end

            c_pixel = getColorPixelInpaintHole(C_V_inpaint_median, C_V_background, i, j);
            C_V_inpaint_hole(i,j,:) = c_pixel;
        end
    end

    if is_show_image
        figure;imshow(uint8(linear2sRGB(C_V_inpaint_median)));
        figure;imshow(uint8(linear2sRGB(C_V_inpaint_hole)));
    end

    %% gamma���� û��

%     C_V = uint8(linear2sRGB(C_V_inpaint_hole));
    C_V = uint8(C_V_inpaint_hole);

end