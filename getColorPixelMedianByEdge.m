function color = getColorPixelMedianByEdge(color,edge,w)
    if size(color,3) ~= 3
		error( 'color data must be of 3 channel' );
    end
	
	color = double(color);
	inputHeight = size( color, 1 );
	inputWidth  = size( color, 2 );
    
    for i = 1 : inputHeight
        for j = 1 : inputWidth
            
            if edge(i,j) == 0
                continue;
            end
            
            iMin = max(i-w,1);
            iMax = min(i+w,inputHeight);
            jMin = max(j-w,1);
            jMax = min(j+w,inputWidth);

            color_sec = color(iMin:iMax,jMin:jMax,:);
            color(i,j,:) = median(median(color_sec));
        end
    end
	
   
end