function Z_inpaint_hole = getDepthPixelInpaintHole2(Z_overlay, Z_background)
    Z_inpaint_hole = Z_overlay;
    directions = 4;
    H = size(Z_overlay, 1);
    W = size(Z_overlay, 2);
    data = zeros(directions,4); %  direction * (2 (overlay and background) * depth and distance)   dir: left right up down
    A = cell(H,W);
    hole_mark = zeros(H,W); % edge 2 hole 1
    
    % to right
    for i = 1 : H
        d = -1;
        z = 0;
        is_edge = 1;
        for j = 1 : W
            d = d + 1;
            if sum(Z_overlay(i,j,:)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(1,1) = z;
                A{i,j}(1,2) = d;
            else
                is_edge = 0;
                d = 0;
                z = Z_overlay(i,j,:);
            end
        end
    end
    % to left
    for i = 1 : H
        d = -1;
        z = 0;
        is_edge = 1;
        for j = W : -1 : 1
            d = d + 1;
            if sum(Z_overlay(i,j,:)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(2,1) = z;
                A{i,j}(2,2) = d;
            else
                is_edge = 0;
                d = 0;
                z = Z_overlay(i,j,:);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        z = 0;
        is_edge = 1;
        for i = 1 : H
            d = d + 1;
            if sum(Z_overlay(i,j,:)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(3,1) = z;
                A{i,j}(3,2) = d;
            else
                is_edge = 0;
                d = 0;
                z = Z_overlay(i,j,:);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        z = 0;
        is_edge = 1;
        for i = H : -1 : 1
            d = d + 1;
            if sum(Z_overlay(i,j,:)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(4,1) = z;
                A{i,j}(4,2) = d;
            else
                is_edge = 0;
                d = 0;
                z = Z_overlay(i,j,:);
            end
        end
    end
       
    % right
    for i = 1 : H
        d = -1;
        z = 0;
        for j = 1 : W
            d = d + 1;
            if sum(Z_background(i,j,:)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(1,3) = z;
                    A{i,j}(1,4) = d;
                end
            else
                d = 0;
                z = Z_background(i,j,:);
            end
        end
    end
    % left
    for i = 1 : H
        d = -1;
        z = 0;
        for j = W : -1 : 1
            d = d + 1;
            if sum(Z_background(i,j,:)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(2,3) = z;
                    A{i,j}(2,4) = d;
                end
            else
                d = 0;
                z = Z_background(i,j,:);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        z = 0;
        for i = 1 : H
            d = d + 1;
            if sum(Z_background(i,j,:)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(3,3) = z;
                    A{i,j}(3,4) = d;
                end
            else
                d = 0;
                z = Z_background(i,j,:);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        z = 0;
        for i = H : -1 : 1
            d = d + 1;
            if sum(Z_background(i,j,:)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(4,3) = z;
                    A{i,j}(4,4) = d;
                end
            else
                d = 0;
                z = Z_background(i,j,:);
            end
        end
    end
    
    for i = 1 : H
        for j = 1 : W
            if hole_mark(i,j) == 0
                continue;
            end
            
            da = A{i,j};
            zs = da(:, 1);
            ds = da(:, 2);
            if hole_mark(i,j) == 1 && sum(sum(sum(da(:, 3)))) ~= 0
                zs = da(:, 3);
                ds = da(:, 4);
            end
            index = sum(zs,2) > 0;
            zs = zs(index);
            ds = ds(index);
            if sum(ds) == 0
                disp('!');
                continue;
            end
            weight_d = 1 ./ ds.^2;
            weight_sum = sum(weight_d);
            weight = weight_d / weight_sum;
            z_pixel = sum(weight .* zs);
            Z_inpaint_hole(i,j,:) = z_pixel;
        end
    end
    
end