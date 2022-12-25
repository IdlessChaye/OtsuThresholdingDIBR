function C_refined = getColorRefinedByDepth(C_O, D_O, edge_mark, color_sigma_w, color_sigma_c, color_window)
    if size(C_O,3) ~= 3
		error( 'color data must be of 3 channel' );
    end
    
    H = size( C_O, 1 );
    W  = size( C_O, 2 );
    C_refined = C_O;
    
    for i = 1 : H
        for j = 1 : W
            if edge_mark(i,j) == 0
                continue;
            end
            C_pixel = getColorPixelBilateralFilterByDepth(C_O,D_O,color_sigma_w,color_sigma_c,color_window,i,j);
            C_refined(i,j,:) = C_pixel;
        end
    end
    
    for i = H : -1 : 1 
        for j = W : -1 : 1
            if edge_mark(i,j) == 0
                continue;
            end
            if sum(C_refined(i,j,:)) ~= 0
                continue;
            end
            C_pixel = getColorPixelBilateralFilterByDepth(C_O,D_O,color_sigma_w,color_sigma_c,color_window,i,j);
            C_refined(i,j,:) = C_pixel;
        end
    end
    
    % fill all pixels, use C_refined to fill
    for i = 1 : H
        for j = 1 : W
            if edge_mark(i,j) == 0
                continue;
            end
            if sum(C_refined(i,j,:)) ~= 0
                continue;
            end
            C_pixel = getColorPixelBilateralFilterByDepth(C_refined,D_O,color_sigma_w,color_sigma_c,color_window,i,j);
            C_refined(i,j,:) = C_pixel;
        end
    end
    
    for i = H : -1 : 1 
        for j = W : -1 : 1
            if edge_mark(i,j) == 0
                continue;
            end
            if sum(C_refined(i,j,:)) ~= 0
                continue;
            end
            C_pixel = getColorPixelBilateralFilterByDepth(C_refined,D_O,color_sigma_w,color_sigma_c,color_window,i,j);
            C_refined(i,j,:) = C_pixel;
        end
    end
end