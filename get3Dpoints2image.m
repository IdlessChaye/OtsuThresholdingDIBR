function image = get3Dpoints2image(homo_points_3D,Rt_v,K_v,Color_Mat_3D,H,W)
image = uint8(zeros(H, W, 3));
z_buffer = uint8(zeros(H,W));
[~, length] = size(homo_points_3D);
points = K_v * Rt_v * homo_points_3D;
zs = points(3,:);
points = points./repmat(zs, [3,1]);
us = round(points(1,:));
vs = round(points(2,:));
for i = 1 : length
    u = us(i);
    v = vs(i);
    z = zs(i);
    if u > 0 && v > 0 && u <= W && v <= H
        z_mark = z_buffer(v, u);
        if z_mark == 0 || z < z_mark
            color = Color_Mat_3D(i,:);
            image(v, u, :) = color;
            z_buffer(v, u) = z;
        end
    end
end

end