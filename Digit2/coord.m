function coord( size1, size2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

M = [0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 10.5...
           11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 21.5...
           22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32]/32;
M1 = [0, 10, 11, 21, 22, 32]/32;
for i = 1:length(M)
    line([1 size2], [M(i) M(i)]*size1, 'color', 'k')
end
for i = 1:length(M1)
    line([1 size2], [M1(i) M1(i)]*size1, 'color', 'k')
end
for i = 1:72
    line([i/72*size2 i/72*size2], [1 size1], 'color', 'k')
end
for i = 1:36
    line([i/36*size2 i/36*size2], [1 size1], 'color', 'k')
end

end

