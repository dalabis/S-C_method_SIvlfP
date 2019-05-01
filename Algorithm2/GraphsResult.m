function GraphsResult(T1, T2, data_out, stepStr)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

figure('Units', 'normalized', 'OuterPosition', [0 0 1 1], 'Name', ['Analysis result: step ', stepStr])

subplot(1,2,1)
plot(data_out(:,1),data_out(:,2),'linestyle','-')
hold on
plot(data_out(:,1),data_out(:,4),'linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
%ylim([0 1])
XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
grid on
xlabel('UT, hours')
ylabel('Reflection coefficient R')
legend('positive direction of time', 'negative direction of time')

subplot(1,2,2)
plot(data_out(:,1),data_out(:,3),'linestyle','-')
hold on
plot(data_out(:,1),data_out(:,5),'linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
%ylim([40 85])
XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
grid on
xlabel('UT, hours')
ylabel('Effictive height h, km')
legend('positive direction of time', 'negative direction of time')

end

