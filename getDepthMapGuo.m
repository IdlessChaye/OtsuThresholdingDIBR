function Z_Map = getDepthMapGuo(Depth_Image,Znear, Zfar)
    Depth_Image = rgb2gray(Depth_Image);
    Depth_Image = double(Depth_Image);

    fB = 32504;
    maxdisp = fB/Znear;
    mindisp = fB/Zfar;
    Z_Map = fB ./ (Depth_Image ./ 255 .* (maxdisp - mindisp) + mindisp);

end