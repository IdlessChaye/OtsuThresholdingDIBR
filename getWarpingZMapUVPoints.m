function [Z_Map, uvs] = getWarpingZMapUVPoints(points, K, Rt, H)    
    UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    Z_Map = double(UVZ(3,:)); % 原来图中所有对应索引的深度映射到了新图中的部分深度
    v_points = [UVZ(1,:)./UVZ(3,:); H - (UVZ(2,:)./UVZ(3,:))]; % [u' v']' reverse v location
    uvs = double(v_points); % 原来图中所有对应索引的uv映射到了新图中的部分uv索引值
end