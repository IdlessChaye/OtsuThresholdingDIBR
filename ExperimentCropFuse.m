close all;
clear;
clc;

finish = imread('Paper/321finish.png');
holefuse = imread('Paper/321holefuse.png');
gtrue = imread('MSR3DVideo-Ballet/Color/color-cam4-f000.jpg');

C_V_Crop = imcrop(finish, [260, 160, 140, 140]);
figure; imshow(C_V_Crop); title('finish'); drawnow;
imwrite(C_V_Crop,['Paper/', '321finish_crop.png']);

C_V_Crop = imcrop(holefuse, [260, 160, 140, 140]);
figure; imshow(C_V_Crop); title('holefuse'); drawnow;
imwrite(C_V_Crop,['Paper/', '321holefuse_crop.png']);

C_V_Crop = imcrop(gtrue, [260, 160, 140, 140]);
figure; imshow(C_V_Crop); title('gtrue'); drawnow;
imwrite(C_V_Crop,['Paper/', '321gtrue_crop.png']);