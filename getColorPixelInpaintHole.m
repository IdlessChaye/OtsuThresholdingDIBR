function c_pixel = getColorPixelInpaintHole(C_overlay, C_background, i, j)
    directions = 4;
    cs = zeros(directions,3);
    ds = zeros(directions,1);
    H = size(C_overlay, 1);
    W = size(C_overlay, 2);
    c_pixel = zeros(1,3);
    
    is_edge = false;
    for n = 1 : 1 % goto
        % up
        d = 1;
        while i - d ~= 0
            if sum(C_background(i - d, j,:)) == 0
                d = d + 1;
            else
                break; % goto
            end
        end
        if i - d == 0
            is_edge = true;
            break;
        else
            cs(1,:) = C_background(i - d, j, :);
            ds(1,1) = d;
        end
        
        % down
        d = 1;
        while i + d ~= H + 1
            if sum(C_background(i + d, j ,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if i + d == H + 1
            is_edge = true;
            break;
        else
            cs(2,:) = C_background(i + d, j, :);
            ds(2,1) = d;
        end
        
        % left
        d = 1;
        while j - d ~= 0
            if sum(C_background(i, j - d,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if j - d == 0
            is_edge = true;
            break;
        else
            cs(3,:) = C_background(i, j - d, :);
            ds(3,1) = d;
        end
        
        % right
        d = 1;
        while j + d ~= W + 1
            if sum(C_background(i, j + d,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if j + d == W + 1
            is_edge = true;
            break;
        else
            cs(4,:) = C_background(i, j + d, :);
            ds(4,1) = d;
        end
    end
    
    % 如果点不在视点边缘，假设造成空洞的原因是因为前景遮挡，根据背景图像进行图像填补
    if is_edge == false % goto
        weight_d = 1 ./ ds.^2;
        weight_sum = sum(weight_d);
        weight= weight_d / weight_sum;
        c_pixel = sum(cat(2,weight,weight,weight) .* cs);
        return;
    end
    
    % 如果点在视点边缘，假设造成空洞的原因是因为视点边缘信息缺失，根据融合图像进行图像填补
    if is_edge == true
        % up
        d = 1;
        while i - d ~= 0
            if sum(C_overlay(i - d, j,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if i - d ~= 0
            cs(1,:) = C_overlay(i - d, j, :);
            ds(1,1) = d;
        end
        
        % down
        d = 1;
        while i + d ~= H + 1
            if sum(C_overlay(i + d, j ,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if i + d ~= H + 1
            cs(2,:) = C_overlay(i + d, j, :);
            ds(2,1) = d;
        end
        
        % left
        d = 1;
        while j - d ~= 0
            if sum(C_overlay(i, j - d,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if j - d ~= 0
            cs(3,:) = C_overlay(i, j - d, :);
            ds(3,1) = d;
        end
        
        % right
        d = 1;
        while j + d ~= W + 1
            if sum(C_overlay(i, j + d,:)) == 0
                d = d + 1;
            else
                break;
            end
        end
        if j + d ~= W + 1
            cs(4,:) = C_overlay(i, j + d, :);
            ds(4,1) = d;
        end
        
        index = ds > 0;
        ds = ds(index);
        cs_r = cs(:,1);
        cs_g = cs(:,2);
        cs_b = cs(:,3);
        cs_r = cs_r(index);
        cs_g = cs_g(index);
        cs_b = cs_b(index);
        cs = cat(2, cs_r, cs_g, cs_b);
        if sum(ds) == 0
            return;
        end
        weight_d = 1 ./ ds.^2;
        weight_sum = sum(weight_d);
        weight= weight_d / weight_sum;
        c_pixel = sum(cat(2,weight,weight,weight) .* cs);
        return;
    end
    
end