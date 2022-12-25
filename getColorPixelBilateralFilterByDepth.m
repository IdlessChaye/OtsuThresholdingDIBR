%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function Name: getColorPixelBilateralFilterByDepth
%Aim: Use the bilateral filter to get a pixel of color map by depth map
%Output: 
%   Result      -   The pixel of color map after bilateral filtering
%Input: 
%   color       -   Color image
%   depth 		-   Depth map
%   sigma_w     -   Coefficient of gaussian kernel for spatial
%   sigma_c     -   Coefficient of gaussian kernel for range
%   w           -   Window size radius
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BF_sigma_w = 3;      % range sigma
% BF_sigma_c = 10;	 % spatial sigma
% BF_window = 10;	   	 % window size - radius
function result = getColorPixelBilateralFilterByDepth(color,depth,sigma_w,sigma_c,w,i,j)
    if size(color,3) ~= 3
		error( 'color data must be of 3 channel' );
	end
	
	%color = double(color);
	inputHeight = size( color, 1 );
	inputWidth  = size( color, 2 );
    [mx,my] = meshgrid(-w:w,-w:w);
    spatial = exp( -(mx.^2 + my.^2) / (2*sigma_w^2) );  
    result = zeros(1,1,3);
	
    iMin = max(i-w,1);
    iMax = min(i+w,inputHeight);
    jMin = max(j-w,1);
    jMax = min(j+w,inputWidth);

    color_sec = color(iMin:iMax,jMin:jMax,:);
    depth_sec = depth(iMin:iMax,jMin:jMax);

    % Compute Gaussian range weights.
    dZ = depth_sec(:,:)-depth(i,j);
    range = exp( -(dZ.^2) / (2*sigma_c^2));

    % Calculate bilateral filter response.
    color_weight = (depth_sec>0) .* (sum(color_sec,3)>0) .* range .* spatial((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1);
    sum_color_weight = sum(color_weight(:));
    color_weight_cat = cat(3, color_weight, color_weight, color_weight);
    color_sum = color_sec .* color_weight_cat;
    result(1,1,1) = sum(sum(color_sum(:,:,1))) / sum_color_weight;
    result(1,1,2) = sum(sum(color_sum(:,:,2))) / sum_color_weight;
    result(1,1,3) = sum(sum(color_sum(:,:,3))) / sum_color_weight;
    if sum(sum(isnan(result))) ~= 0
        result(1,1,:) = 0;
    end
end