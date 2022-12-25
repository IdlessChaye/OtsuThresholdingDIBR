function linear_img = sRGB2linear(sRGB_img) % useless
    % linear_img = ((double(sRGB_img) ./ 255) .^ (2.2)) .* 255;
    linear_img = sRGB_img;
end