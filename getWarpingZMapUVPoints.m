function [Z_Map, uvs] = getWarpingZMapUVPoints(points, K, Rt, H)    
    UVZ = K * Rt * points; % Zc' * [u' v' 1]'
    Z_Map = double(UVZ(3,:)); % ԭ��ͼ�����ж�Ӧ���������ӳ�䵽����ͼ�еĲ������
    v_points = [UVZ(1,:)./UVZ(3,:); H - (UVZ(2,:)./UVZ(3,:))]; % [u' v']' reverse v location
    uvs = double(v_points); % ԭ��ͼ�����ж�Ӧ������uvӳ�䵽����ͼ�еĲ���uv����ֵ
end