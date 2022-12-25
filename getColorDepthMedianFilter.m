function [C, D] = getColorDepthMedianFilter(C_O, D_O, w_radius)
    [H,W] = size(D_O);
    C_R_O = C_O(:,:,1);
    C_G_O = C_O(:,:,2);
    C_B_O = C_O(:,:,3);
    
    D = D_O;
    C = C_O;
    
    for i = 1 : H
        for j = 1 : W
            if sum(C_O(i,j,:)) ~= 0
                continue;
            end
            
            iMin = max(i-w_radius,1);
            iMax = min(i+w_radius,H);
            jMin = max(j-w_radius,1);
            jMax = min(j+w_radius,W);
            d_sec = D_O(iMin:iMax,jMin:jMax);
            pixel_count = sum(d_sec(:) > 0);
            if pixel_count == 0
                continue;
            end

            index = d_sec > 0;
            d_chosen = d_sec(index);
            c_r_sec = C_R_O(iMin:iMax,jMin:jMax);
            c_g_sec = C_G_O(iMin:iMax,jMin:jMax);
            c_b_sec = C_B_O(iMin:iMax,jMin:jMax);
            c_r_chosen = c_r_sec(index);
            c_g_chosen = c_g_sec(index);
            c_b_chosen = c_b_sec(index);
            rows = cat(2, d_chosen, c_r_chosen, c_g_chosen, c_b_chosen);
            rows = sortrows(rows, 1);

            n = floor(pixel_count / 2);
            if n == 0
                n = 1;
            end
            median_row = rows(n, :);
            D(i,j,1) = median_row(1);
            C(i,j,:) = median_row(2:4);
        end
    end
end