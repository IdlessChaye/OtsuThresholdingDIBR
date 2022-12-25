function [W_Dis_L, W_Dis_R] = getWeightViewpointDis(Rt_V_O, Rt_L_O, Rt_R_O)
P_L = [0,0,0,1]';
P_L_V = Rt_V_O * ([Rt_L_O;[0 0 0 1]] \ P_L);
length_L_V = norm(P_L_V);
P_R = [0,0,0,1]';
P_R_V = Rt_V_O * ([Rt_R_O;[0 0 0 1]] \ P_R);
length_R_V = norm(P_R_V);
W_Dis_L = length_R_V / (length_R_V + length_L_V);
W_Dis_R = length_L_V / (length_R_V + length_L_V);
end