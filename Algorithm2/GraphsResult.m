function GraphsResult(data_out, stepStr, units, Algorithm)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    figure('Units', 'normalized', 'OuterPosition', [0 0 1 1], 'Name', ['Analysis result: step ', stepStr])

    subplot(1,2,1)
    if Algorithm == 5
        plot(data_out(:,1),data_out(:,2),'r-',data_out(:,1),data_out(:,4),'r--',...
            data_out(:,1),data_out(:,6),'g-',data_out(:,1),data_out(:,8),'g--',...
            data_out(:,1),data_out(:,10),'b-',data_out(:,1),data_out(:,12),'b--')
    else
        plot(data_out(:,1),data_out(:,2),'-',data_out(:,1),data_out(:,4),'--')
    end
    axis tight
    switch units
        case 1
            XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
            set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
        case 2

    end
    grid on
    xlabel('UT, hours')
    ylabel('Reflection coefficient R')
    if Algorithm == 5
        legend('pos. dir. of time max1', 'neg. dir. of time max1',...
            'pos. dir. of time max2', 'neg. dir. of time max2',...
            'pos. dir. of time max3', 'neg. dir. of time max3')
    else
        legend('positive direction of time', 'negative direction of time')
    end

    subplot(1,2,2)
    if Algorithm == 5
        plot(data_out(:,1),data_out(:,3),'r-',data_out(:,1),data_out(:,5),'r--',...
            data_out(:,1),data_out(:,7),'g-',data_out(:,1),data_out(:,9),'g--',...
            data_out(:,1),data_out(:,11),'b-',data_out(:,1),data_out(:,13),'b--')
    else
        plot(data_out(:,1),data_out(:,3),'-',data_out(:,1),data_out(:,5),'--')
    end
    axis tight
    switch units
        case 1
            XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
            set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
        case 2

    end
    grid on
    xlabel('UT, hours')
    ylabel('Effictive height h, km')
    if Algorithm == 5
        legend('pos. dir. of time max1', 'neg. dir. of time max1',...
            'pos. dir. of time max2', 'neg. dir. of time max2',...
            'pos. dir. of time max3', 'neg. dir. of time max3')
    else
        legend('positive direction of time', 'negative direction of time')
    end

    saveas(gcf,'result.fig')
    saveas(gcf,'result.png')
end

