function value(A, P, size1, size2)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

% изменение размера (костыль)
size1 = fix(size1/32*33);

for i = 1:3
    A(i,:) = 100-A(i,:) -5;
    P(i,:) = 100-P(i,:) -5;
    A(i,:) = (A(i,:)+5)/110*(size1/3);
    P(i,:) = (P(i,:)+5)/110*(size1/3);
    for j = 1:36
        line([(j-1) (j-0.5)]/36*size2, [A(i,j)+(i-1)*(size1/3) A(i,j)+(i-1)*(size1/3)], 'color', 'g', 'linewidth', 2)
        line([(j-0.5) (j)]/36*size2, [P(i,j)+(i-1)*(size1/3) P(i,j)+(i-1)*(size1/3)], 'color', 'b', 'linewidth', 2)
    end
end

end