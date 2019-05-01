function Pre_analysis(filename)
%предобработка и сохранение изображений (формат jpg) с префиксом pre

% Turn off this warning "Warning: Image is too big to fit on screen; displaying at 33% "
warning('off', 'Images:initSize:adjustingMag');

% читаем исходное изображение
in_im = imread([filename]);

% создаем зеленую маску области обработки с порогом
trashhold = 0.8;
green_im = trashhold*in_im(:,:,2)>in_im(:,:,1) & trashhold*in_im(:,:,2)>in_im(:,:,3);

% фильтрация областей касающихся границы (если случайно имеются)
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

% выделение верхней границы
for i = 1:size(green_im,2)
	up_bound(i) = search(green_im(:,i),1);
end

% выделение нижней границы
for i = 1:size(green_im,2)
	down_bound(i) = size(green_im,1)-search(reverse(green_im(:,i)),1);
end

% находим ширину области по вертикали
width = down_bound-up_bound;

% нахождение среднего значения ширины, без учета значений < 0
sum = 0;
n = 0;
for i = 1:length(width)
    if width(i)>0
        sum = sum+width(i);
        n = n+1;
    end
end
average = sum/n;

% присваиваем значение ширины 0, если оно меньше порога (среднее х порог)
trashhold = 0.9;
% число ячеек с шириной больше 0
n = size(in_im,2);
for i = 1:length(width)
    if width(i)<average*trashhold
        width(i) = 0;
        n = n-1;
    end
end

% нахождение минимальной ширины, является шириной нового исправленного
% изображения
min = size(in_im,1);
for i = 1:length(width)
    if width(i)<min && width(i)>0
        min = width(i);
    end
end

% формирования нового исправленного изображения, ширина изображения min 
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
% сетка (непосредтвенно измерена в относительных еденицах)
M = 0:1:32;

% оставляем ТРИ верхние дорожки
new3_im = new_im(round(M(1)/32*size(new_im,1)+1):round(M(end)/32*size(new_im,1)),:,:);

%% преобразование координатной сетки
% x - по вертикали
% y - разница между новыми и старыми координатами по горизонтали
% стрела оружности сетки
f = 0.64/32*size(new_im,1);
% ширина дорожки
h = 10/32*size(new_im,1);
% радиус окружности
r = f/2+1/(2*f)*(h/2)^2;
% координата x
x = 1:1:fix(h);
% промежуточный параметр (радиальное расстояние между хордой и дугой окружности)
% углы небольшие, поэтому пренебрегаем отличием радиального от
% горизонтального расстояния
e = r-sqrt( (h/2-x).^2+r^2-(h/2)^2 );

% новая сетка
M_new = M;

% маска сдвига
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

%сохранение изображения
new_filename = strrep(filename, '.jpg', '_pre.jpg');
new_filename = strrep(filename, '.JPG', '_pre.jpg');
imwrite(out_im,new_filename)