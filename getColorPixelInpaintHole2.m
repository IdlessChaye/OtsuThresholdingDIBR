function C_inpaint_hole = getColorPixelInpaintHole2(C_overlay, C_background)
    C_inpaint_hole = C_overlay;
    directions = 4;
    H = size(C_overlay, 1);
    W = size(C_overlay, 2);
    data = zeros(directions,8); %  direction * (2 (overlay and background) * color and distance)   dir: left right up down
    A = cell(H,W);
    hole_mark = zeros(H,W); % edge 2 hole 1
    
    % to right
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        is_edge = 1;
        for j = 1 : W
            d = d + 1;
            if sum(C_overlay(i,j)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(1,1:3) = c;
                A{i,j}(1,4) = d;
            else
                is_edge = 0;
                d = 0;
                c = C_overlay(i,j);
            end
        end
    end
    % to left
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        is_edge = 1;
        for j = W : -1 : 1
            d = d + 1;
            if sum(C_overlay(i,j)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(2,1:3) = c;
                A{i,j}(2,4) = d;
            else
                is_edge = 0;
                d = 0;
                c = C_overlay(i,j);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        is_edge = 1;
        for i = 1 : H
            d = d + 1;
            if sum(C_overlay(i,j)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(3,1:3) = c;
                A{i,j}(3,4) = d;
            else
                is_edge = 0;
                d = 0;
                c = C_overlay(i,j);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        is_edge = 1;
        for i = H : -1 : 1
            d = d + 1;
            if sum(C_overlay(i,j)) == 0
                hole_mark(i,j) = max(1 + is_edge,hole_mark(i,j));
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(4,1:3) = c;
                A{i,j}(4,4) = d;
            else
                is_edge = 0;
                d = 0;
                c = C_overlay(i,j);
            end
        end
    end
       
    % right
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        for j = 1 : W
            d = d + 1;
            if sum(C_background(i,j)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(1,5:7) = c;
                    A{i,j}(1,8) = d;
                end
            else
                d = 0;
                c = C_background(i,j);
            end
        end
    end
    % left
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        for j = W : -1 : 1
            d = d + 1;
            if sum(C_background(i,j)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(1,5:7) = c;
                    A{i,j}(1,8) = d;
                end
            else
                d = 0;
                c = C_background(i,j);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        for i = 1 : H
            d = d + 1;
            if sum(C_background(i,j)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(3,5:7) = c;
                    A{i,j}(3,8) = d;
                end
            else
                d = 0;
                c = C_background(i,j);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        for i = H : -1 : 1
            d = d + 1;
            if sum(C_background(i,j)) == 0
                if hole_mark(i,j) == 1
                    A{i,j}(4,5:7) = c;
                    A{i,j}(4,8) = d;
                end
            else
                d = 0;
                c = C_background(i,j);
            end
        end
    end
    
    for i = 1 : H
        for j = 1 : W
            if hole_mark(i,j) == 0
                continue;
            end
            
            da = A{i,j};
            cs = da(:, 1:3);
            ds = da(:, 4);
            if hole_mark(i,j) == 1
                cs = da(:, 5:7);
                ds = da(:, 8);
            end
            index = sum(cs,2) > 0;
            cs_r = cs(:,1);
            cs_g = cs(:,2);
            cs_b = cs(:,3);
            cs_r = cs_r(index);
            cs_g = cs_g(index);
            cs_b = cs_b(index);
            cs = cat(2, cs_r, cs_g, cs_b);
            ds = ds(index);
            if sum(ds) == 0
                disp('!');
                continue;
            end
            weight_d = 1 ./ ds.^2;
            weight_sum = sum(weight_d);
            weight = weight_d / weight_sum;
            c_pixel = sum(cat(2,weight,weight,weight) .* cs);
            C_inpaint_hole(i,j,:) = c_pixel;
        end
    end
    
end