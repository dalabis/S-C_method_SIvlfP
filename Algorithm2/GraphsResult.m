function GraphsResult(data_out, stepStr, units)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

figure('Units', 'normalized', 'OuterPosition', [0 0 1 1], 'Name', ['Analysis result: step ', stepStr])

subplot(1,2,1)
plot(data_out(:,1),data_out(:,2),'linestyle','-')
hold on
plot(data_out(:,1),data_out(:,4),'linestyle','--')
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
legend('positive direction of time', 'negative direction of time')

subplot(1,2,2)
plot(data_out(:,1),data_out(:,3),'linestyle','-')
hold on
plot(data_out(:,1),data_out(:,5),'linestyle','--')
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
legend('positive direction of time', 'negative direction of time')

saveas(gcf,'result.fig')
saveas(gcf,'result.png')
end

