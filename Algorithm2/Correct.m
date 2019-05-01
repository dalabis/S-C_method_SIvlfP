function dataOut = Correct(dataIn)
% correct the data
% 1. remove breaks
% 2. correct beginning of the track
% 3. transfer phases to microsec
% in matr(x, 7)
% out matr(x, 7)

minValue = [1, -1, 0];
maxValue = [100, 100, 95];
dataTemp = [    dataIn(:,1), ...
                ( dataIn(:,2) - minValue(1) ) ./ ( maxValue(1) - minValue(1) ) .* 100, ...
                ( dataIn(:,3) - minValue(2) ) ./ ( maxValue(2) - minValue(2) ) .* 100, ...
            	( dataIn(:,4) - minValue(3) ) ./ ( maxValue(3) - minValue(3) ) .* 100, ...
                ( dataIn(:,5) - minValue(1) ) ./ ( maxValue(1) - minValue(1) ) .* 100, ...
                ( dataIn(:,6) - minValue(2) ) ./ ( maxValue(2) - minValue(2) ) .* 100, ...
                ( dataIn(:,7) - minValue(3) ) ./ ( maxValue(3) - minValue(3) ) .* 100, ...
                ];

for i = 2 : 7
    for j = 2 : size(dataTemp, 1)
        if abs( ( dataTemp(j, i) + 100 ) - dataTemp(j - 1, i) ) < abs( dataTemp(j, i) - dataTemp(j - 1, i) )
            dataTemp(j, i) = dataTemp(j, i) + 100;
        elseif abs( ( dataTemp(j, i) - 100 ) - dataTemp(j - 1, i) ) < abs( dataTemp(j, i) - dataTemp(j - 1, i) )
            dataTemp(j, i) = dataTemp(j, i) - 100;
        end
    end
end

dataTemp(:, 5:7) = - dataTemp(:, 5:7) / 5;
dataTemp(:, 5) = dataTemp(:, 5) - dataTemp(1, 5);
dataTemp(:, 6) = dataTemp(:, 6) - dataTemp(1, 6);
dataTemp(:, 7) = dataTemp(:, 7) - dataTemp(1, 7);

dataOut = dataTemp;