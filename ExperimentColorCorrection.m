close all;
clear;
clc;

pics_dir = './';

C_V = imread([pics_dir, '1.png']);
figure; imshow(C_V); title('1'); drawnow;
C_V_Crop = imcrop(C_V, [290, 130, 160, 200]);
figure; imshow(C_V_Crop); title('ba4 70'); drawnow;
imwrite(C_V_Crop,[pics_dir, '1_Crop.png']);

C_V = imread([pics_dir, '2.png']);
C_V_Crop = imcrop(C_V, [290, 130, 160, 200]);
figure; imshow(C_V_Crop); title('2'); drawnow;
imwrite(C_V_Crop,[pics_dir, '2_Crop.png']);