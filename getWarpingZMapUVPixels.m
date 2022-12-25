function [Z_Map, uvs] = getWarpingZMapUVPixels(points, K, Rt, H, W)
    % UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    % Z_Map = double(reshape(UVZ(3,:),H,W)); % ԭ��ͼ�����ж�Ӧ���������ӳ�䵽����ͼ�еĲ������
    % v_points = [UVZ(1,:)./UVZ(3,:);UVZ(2,:)./UVZ(3,:)]; % [u' v']'
    % uvs = cat(3,reshape(v_points(1,:), H,W),reshape(v_points(2,:), H,W)); % H * W * [u' v']'
    % uvs = double(uvs); % ԭ��ͼ�����ж�Ӧ������uvӳ�䵽����ͼ�еĲ���uv����ֵ

    UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    Z_Map = double(reshape(UVZ(3,:),H,W)); % ԭ��ͼ�����ж�Ӧ���������ӳ�䵽����ͼ�еĲ������
    v_points = [UVZ(1,:)./UVZ(3,:);UVZ(2,:)./UVZ(3,:)]; % [u' v']' 
    uvs = cat(3,reshape(v_points(1,:), H,W),H - reshape(v_points(2,:), H,W)); % H * W * [u' v']' reverse v location
    uvs = double(uvs); % ԭ��ͼ�����ж�Ӧ������uvӳ�䵽����ͼ�еĲ���uv����ֵ

end