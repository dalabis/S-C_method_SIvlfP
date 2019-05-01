function [ A, P ] = Analysis( filename, trashhold )
%Analysis �������������� ��������� ������������� �����������
%   ����� ������������� �������� Pre_analysis ��������� ����� ����������� �
%   ���������� '_pre', ��� � ������������ ��� ���������; �������� ������� -
%   ��������� � ���� ������������ �������� ��� �������������

% Turn off this warning "Warning: Image is too big to fit on screen; displaying at 33% "
warning('off', 'Images:initSize:adjustingMag');

% ������ �������� �����������
in_im = imread(filename);

% ���������� ������ (�� ��������� ������ � �����) (�������)
in_imPlus(1:fix(size(in_im,1)/32*33),1:size(in_im,2),1:3) = 0;
in_imPlus(fix(size(in_im,1)/64):fix(size(in_im,1)/64)+size(in_im,1)-1,:,:) = in_im;
in_im = in_imPlus;

% ������� ������� ����� ������� ��������� � �������
red_im = trashhold*in_im(:,:,1)>in_im(:,:,2) & trashhold*in_im(:,:,1)>in_im(:,:,3);
% ������� ����� ��� ��������� ���������
BW = bwmorph(red_im, 'erode', 10);
amp_im = bwmorph(BW, 'dilate', 10);

% ������ ������� ��� ����� ��� ������ �� ���� ������� � ������
for i = 1:3
    for j = 1:size(amp_im,2)
        n = 1+(i-1)*fix(size(amp_im,1)/3);
        while ~amp_im(n,j) && n~=i*fix(size(amp_im,1)/3)
            n = n+1;
        end
        if n == i*fix(size(amp_im,1)/3)
            amp_mask(i,j) = 0;
        else
            amp_mask(i,j) = 1;
        end
    end
end

% ���������� �������� �������� � ��� � ������������� �������� ����������
% ��� ���� �������
for i = 1:3
    for j = 1:size(red_im,2)
        n = 1+(i-1)*fix(size(red_im,1)/3);
        while ~red_im(n,j) && n~=i*fix(size(red_im,1)/3)
            n = n+1;
        end
        AP_line(i,j) = i*fix(size(red_im,1)/3)-n;
    end
end

% ���������� ����� ����
ph_mask = ~amp_mask;

% ������ ����� ��������� � ����
for i = 1:3
    amp_mask(i,:) = erode_array(amp_mask(i,:),10);
    ph_mask(i,:) = erode_array(ph_mask(i,:),10);
end

% �������� ��������� ������������� ����������� �������� ����� � ������������� �������� �� 100 �
% ��� ��������� ����� ��������� true
% �������� ���� ������������� ����������� �������� ���� �� 100 � ���
% �������� ����� ��������� false
for i = 1:3
    for j = 1:36
        A(i,j) = fix(size(red_im,1)/3);
        P(i,j) = fix(size(red_im,1)/3);
        for k = 1:fix(length(AP_line)/36)
            if amp_mask(i,k+(j-1)*fix(length(AP_line)/36)) && ...
                    AP_line(i,k+(j-1)*fix(length(AP_line)/36)) < A(i,j)
                A(i,j) = AP_line(i,k+(j-1)*fix(length(AP_line)/36));
            elseif ph_mask(i,k+(j-1)*fix(length(AP_line)/36)) && ...
                    AP_line(i,k+(j-1)*fix(length(AP_line)/36)) < P(i,j)
                P(i,j) = AP_line(i,k+(j-1)*fix(length(AP_line)/36));
            end
        end
    end
end

% ��������������� �� �������� � �������� ������� (110)
A = A/fix(size(red_im,1)/3)*110;
P = P/fix(size(red_im,1)/3)*110;
% ����� �� 5 �������� ������
A = A-5;
P = P-5;

end

