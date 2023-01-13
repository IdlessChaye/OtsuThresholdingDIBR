function C_inpaint_hole = getColorPixelInpaintHole3(C_overlay)
    C_inpaint_hole = C_overlay;
    directions = 4;
    H = size(C_overlay, 1);
    W = size(C_overlay, 2);
    data = zeros(directions,4); %  direction * (1(overlay) * color and distance)   dir: left right up down
    A = cell(H,W);
    hole_mark = zeros(H,W); % hole 1
    
    % to right
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        for j = 1 : W
            d = d + 1;
            if sum(C_overlay(i,j,:)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(1,1:3) = c;
                A{i,j}(1,4) = d;
            else
                d = 0;
                c = C_overlay(i,j,:);
            end
        end
    end
    % to left
    for i = 1 : H
        d = -1;
        c = zeros(1,3);
        for j = W : -1 : 1
            d = d + 1;
            if sum(C_overlay(i,j,:)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(2,1:3) = c;
                A{i,j}(2,4) = d;
            else
                d = 0;
                c = C_overlay(i,j,:);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        for i = 1 : H
            d = d + 1;
            if sum(C_overlay(i,j,:)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(3,1:3) = c;
                A{i,j}(3,4) = d;
            else
                d = 0;
                c = C_overlay(i,j,:);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        c = zeros(1,3);
        for i = H : -1 : 1
            d = d + 1;
            if sum(C_overlay(i,j,:)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(4,1:3) = c;
                A{i,j}(4,4) = d;
            else
                d = 0;
                c = C_overlay(i,j,:);
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