function Pre_analysis(filename)
%������������� � ���������� ����������� (������ jpg) � ��������� pre

% Turn off this warning "Warning: Image is too big to fit on screen; displaying at 33% "
warning('off', 'Images:initSize:adjustingMag');

% ������ �������� �����������
in_im = imread([filename]);

% ������� ������� ����� ������� ��������� � �������
trashhold = 0.8;
green_im = trashhold*in_im(:,:,2)>in_im(:,:,1) & trashhold*in_im(:,:,2)>in_im(:,:,3);

% ���������� �������� ���������� ������� (���� �������� �������)
STATS = regionprops(~green_im,'Area','BoundingBox');
if size(STATS,1)>1
    max = STATS(1).Area;
    n = 1;
    for i = 2:size(STATS,1)
        if STATS(i).Area>max
            max = STATS(i).Area;
            n = i;
        end
    end
    for i = 1:size(STATS,1)
        if i ~= n
            Bound = STATS(i).BoundingBox;
            green_im(uint16(Bound(2)):uint16(Bound(2)+Bound(4))-1,uint16(Bound(1)):uint16(Bound(1)+Bound(3))-1) = 1;
        end
    end
end

% ��������� ������� �������
for i = 1:size(green_im,2)
	up_bound(i) = search(green_im(:,i),1);
end

% ��������� ������ �������
for i = 1:size(green_im,2)
	down_bound(i) = size(green_im,1)-search(reverse(green_im(:,i)),1);
end

% ������� ������ ������� �� ���������
width = down_bound-up_bound;

% ���������� �������� �������� ������, ��� ����� �������� < 0
sum = 0;
n = 0;
for i = 1:length(width)
    if width(i)>0
        sum = sum+width(i);
        n = n+1;
    end
end
average = sum/n;

% ����������� �������� ������ 0, ���� ��� ������ ������ (������� � �����)
trashhold = 0.9;
% ����� ����� � ������� ������ 0
n = size(in_im,2);
for i = 1:length(width)
    if width(i)<average*trashhold
        width(i) = 0;
        n = n-1;
    end
end

% ���������� ����������� ������, �������� ������� ������ �������������
% �����������
min = size(in_im,1);
for i = 1:length(width)
    if width(i)<min && width(i)>0
        min = width(i);
    end
end

% ������������ ������ ������������� �����������, ������ ����������� min 
new_im(1:min,1:n,1:3) = 0;
j = 1;
for i = 1:length(width)
    if width(i)>0
        for k = 1:down_bound(i)-up_bound(i)+1
            new_im(round(k/(down_bound(i)-up_bound(i))*min),j,:) = in_im(k+up_bound(i)-1,i,:);
        end
        j = j+1;
    end
end
%%
% ����� (�������������� �������� � ������������� ��������)
M = 0:1:32;

% ��������� ��� ������� �������
new3_im = new_im(round(M(1)/32*size(new_im,1)+1):round(M(end)/32*size(new_im,1)),:,:);

%% �������������� ������������ �����
% x - �� ���������
% y - ������� ����� ������ � ������� ������������ �� �����������
% ������ ��������� �����
f = 0.64/32*size(new_im,1);
% ������ �������
h = 10/32*size(new_im,1);
% ������ ����������
r = f/2+1/(2*f)*(h/2)^2;
% ���������� x
x = 1:1:fix(h);
% ������������� �������� (���������� ���������� ����� ������ � ����� ����������)
% ���� ���������, ������� ������������ �������� ����������� ��
% ��������������� ����������
e = r-sqrt( (h/2-x).^2+r^2-(h/2)^2 );

% ����� �����
M_new = M;

% ����� ������
Delta(1:size(new3_im,1)) = 0;
Delta(fix(M_new(1)/32*size(new3_im,1))+1:fix(M_new(1)/32*size(new3_im,1))+length(e)) = e;
Delta(fix(M_new(12)/32*size(new3_im,1))+1:fix(M_new(12)/32*size(new3_im,1))+length(e)) = e;
Delta(fix(M_new(23)/32*size(new3_im,1))+1:fix(M_new(23)/32*size(new3_im,1))+length(e)) = e;

pre_im(1:size(new3_im,1),1:size(new3_im,2),1:3) = 0;

for i = 1:size(new3_im,2)
    for j = 1:size(new3_im,1)
        if fix(i+Delta(j))<size(new3_im,2)
            pre_im(j,fix(i+Delta(j)),:) = new3_im(j,i,:);
        end
    end
end

out_im = uint8(pre_im);

%���������� �����������
new_filename = strrep(filename, '.jpg', '_pre.jpg');
new_filename = strrep(filename, '.JPG', '_pre.jpg');
imwrite(out_im,new_filename)