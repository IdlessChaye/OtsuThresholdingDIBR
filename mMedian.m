function C_output = mMedian(C, w_radius)
    C_output = C;
    H = size(C,1);
    W = size(C,2);
    d = size(C,3);
    if d == 1
        for i = 1 : H
            for j = 1 : W
                iMin = max(i-w_radius,1);
                iMax = min(i+w_radius,H);
                jMin = max(j-w_radius,1);
                jMax = min(j+w_radius,W);
                c_sec = C(iMin:iMax,jMin:jMax);
                c_sec = c_sec(:);
                count = size(c_sec,1);
                if mod(count,2) == 0
                    C_output(i,j,1) = median(c_sec);
                else
                    c_sec(end + 1) = 0;
                    C_output(i,j,1) = median(c_sec);
                end
            end
        end
    end
end