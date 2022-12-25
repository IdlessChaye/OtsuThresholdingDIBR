function [D, C] = getDepthColorRefinement(D_O, C_O)
%DepthColorRefinement
% �ȶ����ͼ���п�������ʹ���ͼ��Сì����ʧ
% �ٶ����ͼ����˫���˲������ϱ���ƽ��
% Ȼ������ͼ���б�Ե��⣬���Ա�Ե����һ�����أ����ͼ��Ե���Ĳ�ɫ������
% �Բ�ɫͼ�����οպ������ɫͼ������������ȷ��������������������������ȣ�ѡ�����˫���˲����л�����ɫͼ�Ŀռ�����������Ƶ�˫���˲�
% D_O H*W   double ��������ͼ
% C_O H*W*3 double �������ɫͼ
% D   H*W   double ��������ͼ
% C   H*W*3 double �������ɫͼ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

is_show_figure = false;

if is_show_figure
    figure;
    imshow(uint8(D_O));
end

SE = strel('square', 3);
D_open = imopen(D_O, SE);
if is_show_figure
    figure;
    imshow(uint8(D_open));
end

%D = D_open(:,:,1);
depth_sigma_w = 3;   % spatial sigma
depth_sigma_c = 10;	 % value sigma
depth_window = 2;	 % window size - radius
D = getDepthBilateralFilter(D_open,depth_sigma_w,depth_sigma_c,depth_window);
if is_show_figure
    figure;
    imshow(uint8(D));
end

D_edge = edge(D, 'canny');
if is_show_figure
    figure;
    imshow(D_edge);
    D_edge_remain = 1 - D_edge;
    D_edge_remain = cat(3, D_edge_remain,D_edge_remain,D_edge_remain);
    C_edge_remain = C_O .* D_edge_remain;
    figure;
    imshow(uint8(C_edge_remain));
end

SE_edge_dilate = strel('square', 4);
D_edge_dilate = imdilate(D_edge, SE_edge_dilate);
D_edge_dilate_remain = 1 - D_edge_dilate;
D_edge_dilate_remain = cat(3, D_edge_dilate_remain,D_edge_dilate_remain,D_edge_dilate_remain);
C_edge_dilate_remain = C_O .* D_edge_dilate_remain;
if is_show_figure
    figure;
    imshow(D_edge_dilate);
    figure;
    imshow(uint8(C_edge_dilate_remain));
end

color_sigma_w = 3;   % spatial sigma
color_sigma_c = 1;	 % value sigma
color_window = 2;	 % window size - radius
C_output = getColorRefinedByDepth(C_edge_dilate_remain, D, D_edge_dilate, color_sigma_w, color_sigma_c, color_window);
if is_show_figure
    figure;
    imshow(uint8(C_output));
    figure;
    imshow(uint8(C_O));
end

C = C_output;

end