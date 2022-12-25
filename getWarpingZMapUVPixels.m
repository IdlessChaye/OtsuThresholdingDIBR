function [Z_Map, uvs] = getWarpingZMapUVPixels(points, K, Rt, H, W)
    % UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    % Z_Map = double(reshape(UVZ(3,:),H,W)); % 原来图中所有对应索引的深度映射到了新图中的部分深度
    % v_points = [UVZ(1,:)./UVZ(3,:);UVZ(2,:)./UVZ(3,:)]; % [u' v']'
    % uvs = cat(3,reshape(v_points(1,:), H,W),reshape(v_points(2,:), H,W)); % H * W * [u' v']'
    % uvs = double(uvs); % 原来图中所有对应索引的uv映射到了新图中的部分uv索引值

    UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    Z_Map = double(reshape(UVZ(3,:),H,W)); % 原来图中所有对应索引的深度映射到了新图中的部分深度
    v_points = [UVZ(1,:)./UVZ(3,:);UVZ(2,:)./UVZ(3,:)]; % [u' v']' 
    uvs = cat(3,reshape(v_points(1,:), H,W),H - reshape(v_points(2,:), H,W)); % H * W * [u' v']' reverse v location
    uvs = double(uvs); % 原来图中所有对应索引的uv映射到了新图中的部分uv索引值

end