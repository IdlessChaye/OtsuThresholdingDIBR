function depth = getDepthPixelMedianByEdge(depth,edge,w)
    if size(depth,3) ~= 1
		error( 'depth data must be of 1 channel' );
    end
	
	depth = double(depth);
	inputHeight = size( depth, 1 );
	inputWidth  = size( depth, 2 );
    
    for i = 1 : inputHeight
        for j = 1 : inputWidth
            
            if edge(i,j) == 0
                continue;
            end
            
            iMin = max(i-w,1);
            iMax = min(i+w,inputHeight);
            jMin = max(j-w,1);
            jMax = min(j+w,inputWidth);

            depth_sec = depth(iMin:iMax,jMin:jMax,:);
            depth(i,j,:) = mean(mean(depth_sec));
        end
    end
	
   
end