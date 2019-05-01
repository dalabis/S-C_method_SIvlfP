function out = search(in,start)
%поиск границы в бинарном массиве (тип границы 1 -> 0)
%для границы 0 -> 1 используй ~in
%start - начальное положение
n = start;
while in(n) && n<length(in)
    n=n+1;
end
out = n;
end

