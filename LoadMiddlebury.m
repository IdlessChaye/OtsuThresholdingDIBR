% https://vision.middlebury.edu/stereo/data/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dataset = 'Aloe';
% dataset = 'Art';
% dataset = 'Bowling1';
% dataset = 'Midd2';
% dataset = 'Moebius';
% dataset = 'Reindeer';
cam_V = 3;

focal_length = 3740;
baseline = 160;
scale = 1;
dataset_dir = ['Middlebury/', dataset, '/'];

dmin = 0;
if strcmp(dataset,'Aloe')
    dmin = 270;
elseif strcmp(dataset,'Art')
    dmin = 200;
elseif strcmp(dataset,'Bowling1')
    dmin = 290;
elseif strcmp(dataset,'Midd2')
    dmin = 214;
elseif strcmp(dataset,'Moebius')
    dmin = 200;
elseif strcmp(dataset,'Reindeer')
    dmin = 230;
end

xoffset = 40;
C_L_O = double(imread([dataset_dir, 'view1.png']));
C_R_O = double(imread([dataset_dir, 'view5.png']));
C_V_O = imread([dataset_dir, 'view',num2str(cam_V,'%01d'),'.png']);
disparity_L = double(imread([dataset_dir, 'disp1.png']));
disparity_R = double(imread([dataset_dir, 'disp5.png']));
[H, W, ~] = size(disparity_L);
K = [focal_length, 0,            W/2;
     0,            focal_length, H/2;
     0,            0,            1   ];
K_L = K;
K_R = K;
K_V = K;
Rt_L = ([eye(3), [-xoffset*(0) 0 0]']);
Rt_R = ([eye(3), [-xoffset*(4) 0 0]']);
Rt_V = ([eye(3), [-xoffset*(cam_V-1) 0 0]']);
disparity_L = disparity_L / scale + dmin;
disparity_L = disparity_L .* (disparity_L ~= dmin);
D_L_O = baseline * focal_length ./ disparity_L;
disparity_R = disparity_R / scale + dmin;
disparity_R = disparity_R .* (disparity_R ~= dmin);
D_R_O = baseline * focal_length ./ disparity_R;
Znear = min(min(D_L_O(:)),min(D_R_O(:)));
Zfar = max(max(D_L_O(:)),max(D_R_O(:)));

