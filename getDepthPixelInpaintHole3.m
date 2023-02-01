function Z_inpaint_hole = getDepthPixelInpaintHole3(Z_overlay)
    Z_inpaint_hole = Z_overlay;
    directions = 4;
    H = size(Z_overlay, 1);
    W = size(Z_overlay, 2);
    data = zeros(directions,2); %  direction * (1(overlay) * color and distance)   dir: left right up down
    A = cell(H,W);
    hole_mark = zeros(H,W); % hole 1
    
    % to right
    for i = 1 : H
        d = -1;
        z = 0;
        for j = 1 : W
            d = d + 1;
            if sum(Z_overlay(i,j)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(1,1) = z;
                A{i,j}(1,2) = d;
            else
                d = 0;
                z = Z_overlay(i,j);
            end
        end
    end
    % to left
    for i = 1 : H
        d = -1;
        z = 0;
        for j = W : -1 : 1
            d = d + 1;
            if sum(Z_overlay(i,j)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(2,1) = z;
                A{i,j}(2,2) = d;
            else
                d = 0;
                z = Z_overlay(i,j);
            end
        end
    end
    % down
    for j = 1 : W
        d = -1;
        z = 0;
        for i = 1 : H
            d = d + 1;
            if sum(Z_overlay(i,j)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(3,1) = z;
                A{i,j}(3,2) = d;
            else
                d = 0;
                z = Z_overlay(i,j);
            end
        end
    end
    % up
    for j = 1 : W
        d = -1;
        z = 0;
        for i = H : -1 : 1
            d = d + 1;
            if sum(Z_overlay(i,j)) == 0
                hole_mark(i,j) = 1;
                if isempty(A{i,j})
                    A{i,j} = data;
                end
                A{i,j}(4,1) = z;
                A{i,j}(4,2) = d;
            else
                d = 0;
                z = Z_overlay(i,j);
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
            index = sum(zs,2) ~= 0;
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