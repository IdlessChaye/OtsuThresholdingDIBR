function Rt = getCOLMAPRt(qtvec)

[~,B] = size(qtvec);
if B ~= 7
    Rt = [];
    return;
end

q1 = qtvec(1:4);
q1=quatnormalize(q1);
r1=quat2dcm(q1);
r1=r1';

t = qtvec(5:7)';
%t = -r1*t;

Rt = [r1 t];
%Rt(3,:) = -Rt(3,:);

end