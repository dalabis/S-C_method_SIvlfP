function in_data = Awaraging(in_data, average)
    switch average
        case 2
            in_data_case2 = in_data; 
            for i = 2:size(in_data,1)-1
                in_data_case2(i,2:7) = (in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7))/3;
            end
            in_data = in_data_case2(2:size(in_data,1)-1,:);
        case 3
            in_data_case3 = in_data;
            for i = 3:size(in_data,1)-2
                in_data_case3(i,2:7) = (in_data(i-2,2:7)+in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7)+in_data(i+2,2:7))/5;
            end
            in_data = in_data_case3(3:size(in_data,1)-2,:);
        case 4
            in_data_case4 = in_data;
            for i = 4:size(in_data,1)-3
                in_data_case4(i,2:7) = (in_data(i-3,2:7)+in_data(i-2,2:7)+in_data(i-1,2:7)+in_data(i,2:7)+in_data(i+1,2:7)+in_data(i+2,2:7)+in_data(i+3,2:7))/7;
            end
            in_data = in_data_case4(4:size(in_data,1)-3,:);
    end
end

