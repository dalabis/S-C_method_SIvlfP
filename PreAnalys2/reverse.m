function out = reverse( in )
%function reverse input massive

mass(1:length(in)) = 0;

for i = 1:length(in)
    mass(length(mass)-i+1) = in(i);
end

out = mass;

end

