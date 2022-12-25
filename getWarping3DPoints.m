function points = getWarping3DPoints(K,Rt,Z_Map)
% K: 3 * 3
% Rt: 3 * 4
% Z_Map: H * W * 1
% points: [4, H*W] [Xw Yw Zw 1]'

    [H, W] = size(Z_Map);
    [X,Y] = meshgrid(1:W, H:-1:1); % reverse v location
    Cam_XYZ = [X(:)';Y(:)';ones(1,W*H)]; % [u v 1]'
    D_mat = [Z_Map(:)';Z_Map(:)';Z_Map(:)']; % [Zc Zc Zc]'
    Cam_XYZ = K \ (D_mat .* Cam_XYZ); % [Xc Yx Zc]'  [3,H*W]
    points = [Cam_XYZ; ones(1, H * W)];
    Rt4x4 = [Rt;[0 0 0 1]]; % Rt4x4
    points = Rt4x4\points; % original world sapce 3D points

end