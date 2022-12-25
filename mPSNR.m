function psnr = mPSNR(A,B,bit)

    mse = mean(mean(mean((A - B).^2)));

    MAX_I = 2^bit - 1; % if bit == 8 then MAX_I == 255
    psnr = 10 * log10(MAX_I^2 / mse);
    
    psnr = mean(psnr);
end