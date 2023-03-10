function [L,R] = getColorCorrectedSimple(L,R)
    hsv_L_O = rgb2hsv(L);
    hsv_R_O = rgb2hsv(R);
    for chan = 3 : 3
        light_L_O = mean(mean(hsv_L_O(:,:,chan)));
        light_R_O = mean(mean(hsv_R_O(:,:,chan)));
        hsv_L_O(:,:,chan) = hsv_L_O(:,:,chan) ./ light_L_O .* light_R_O;
    end
    L = hsv2rgb(hsv_L_O);
    R = hsv2rgb(hsv_R_O);
end