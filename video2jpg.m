clc,clear;
Path = 'D:\G_treasures\CSLAB\Datasets\Guo\A_Basketball_Player\RGB\';

for camNumber = 0 : 11
    ob = VideoReader([Path, num2str(camNumber), '.mp4']);
    get(ob);
    n = 30;
    for i = 1 : n
        a = read(ob,i);
        %imshow(a);
        str = [Path, 'color-cam',num2str(camNumber),'-f', num2str(i-1,'%03d'), '.jpg'];
        imwrite(a,str);
    end
end