function sRGB_img = linear2sRGB(linear_img) % useless
%     sRGB_img = ((double(linear_img) ./ 255) .^ (1 / 2.2)) .* 255;
    sRGB_img = linear_img;
end