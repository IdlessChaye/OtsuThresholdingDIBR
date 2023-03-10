function threshes = getAvgThresh(Z_L_O, thresh_number)

    Z_L_O = Z_L_O(:,:,1);

    max_value = max(max(Z_L_O));
    min_value = min(min(Z_L_O));
    delta = (max_value - min_value) / (thresh_number + 1);

    threshes = zeros(1,thresh_number);
    for i = 1 : thresh_number
        threshes(i) = min_value + delta * i;
    end

end