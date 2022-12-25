%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function Name: getDepthBilateralFilter
%Aim: Use the bilateral filter to filter the map
%Output: 
%   Result      -   The output map after bilateral filtering
%Input: 
%   map         -   Color image or depth map
%   sigma_w     -   Coefficient of gaussian kernel for spatial
%   sigma_c     -   Coefficient of gaussian kernel for range
%   w           -   Window size radius
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BF_sigma_w = 3;      % range sigma
% BF_sigma_c = 10;	 % spatial sigma
% BF_window = 10;	   	 % window size - radius
function result = getDepthBilateralFilter(depth,sigma_w,sigma_c,w)	
	depth = double(depth);
	inputHeight = size( depth, 1 );
	inputWidth  = size( depth, 2 );
    [mx,my] = meshgrid(-w:w,-w:w);
    spatial = exp( -(mx.^2 + my.^2) / (2*sigma_w^2) );  
    result = zeros(inputHeight,inputWidth);
	
    for i = 1:inputHeight
        for j = 1:inputWidth
             % Extract local region.
             iMin = max(i-w,1);
             iMax = min(i+w,inputHeight);
             jMin = max(j-w,1);
             jMax = min(j+w,inputWidth);
			 
             depth_sec = depth(iMin:iMax,jMin:jMax);
			 
             % Compute Gaussian range weights.
             dZ = depth_sec(:,:)-depth(i,j);
             range = exp( -(dZ.^2) / (2*sigma_c^2));

             % Calculate bilateral filter response.
             depth_weight = (depth_sec>0) .* range .* spatial((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
             depth_sum = depth_sec .* depth_weight;
             result(i,j) = sum(depth_sum(:)) / sum(depth_weight(:));
             if(isnan(result(i,j)))
                 result(i,j) = 0;
             end
        end
    end
end