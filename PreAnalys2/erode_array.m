function out = erode_array( in, n )
%erode_array Ёрози€ логического массива
%   Ёрози€ логического массива n раз

for i = 1:n
    array = in;
    for j = 1:length(in)-1
        if (in(j)&&~in(j+1))||(~in(j)&&in(j+1))
            array(j) = 0;
            array(j+1) = 0;
        end
    end
    in = array;
end

out = in;

end

