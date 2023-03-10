function [D, C] = getDepthColorRefinementSimple(D_O, C_O)
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

z_sign = D_O(1) / abs(D_O(1));
D_O = D_O * z_sign;

if is_show_figure
    figure;
    imshow(uint8(D_O));
end

%D = D_open(:,:,1);
depth_sigma_w = 3;   % spatial sigma
depth_sigma_c = 10;	 % value sigma
depth_window = 2;	 % window size - radius
D = getDepthBilateralFilter(D_O,depth_sigma_w,depth_sigma_c,depth_window);
if is_show_figure
    figure;
    imshow(uint8(D));
end

C = C_O;
D = D * z_sign;

end