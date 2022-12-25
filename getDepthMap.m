function Z_Map = getDepthMap(Depth_Image,Znear, Zfar)

    Depth_Image = rgb2gray(Depth_Image);
    Depth_Image = double(Depth_Image);
    c = ((1/Znear) - (1/Zfar))/255;
    Z_Map = 1./(Depth_Image.*c+(1/Zfar));

end