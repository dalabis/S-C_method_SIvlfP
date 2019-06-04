function GraphsComparison(T1, T2, in_data, data_out, GG, stepStr, averageStr, units)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure('Units', 'normalized', 'OuterPosition', [0 0 1 1], 'Name', ['Comparing theory with experiment: step ', stepStr])

for i = 1:size(data_out,1)
    W_f1_forw(i) = W(1,data_out(i,2),data_out(i,3),0);
    W_f1_back(i) = W(1,data_out(i,4),data_out(i,5),0);
    W_f2_forw(i) = W(2,data_out(i,2),data_out(i,3),0);
    W_f2_back(i) = W(2,data_out(i,4),data_out(i,5),0);
    W_f3_forw(i) = W(3,data_out(i,2),data_out(i,3),0);
    W_f3_back(i) = W(3,data_out(i,4),data_out(i,5),0);
end

subplot(2,3,1)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,2)/in_data(T1,2),'color','b','linestyle','-')
plot(data_out(:,1),abs(W_f1_forw)/abs(W_f1_forw(1)),'color','b','linestyle','--')
plot(data_out(:,1),abs(W_f1_back)/abs(W_f1_back(end))*in_data(T2,2)/in_data(T1,2),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(1,:) = get(gca,'YLim');
G1 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Ampl, 10.2kHz')
% discription is on a first graph
legend(...
        ['experiment, num of points ', num2str(size(in_data(T1:T2,:),1)), ' with time step ', stepStr, ' (', averageStr, ')'],...
        ['theory (positive dir.), discrepancy fun. G= ', num2str(GG(1))],...
        ['theory (negative dir.), discrepancy fun. G= ', num2str(GG(2))]...
    )

subplot(2,3,2)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,3)/in_data(T1,3),'color','b','linestyle','-')
plot(data_out(:,1),abs(W_f2_forw)/abs(W_f2_forw(1)),'color','b','linestyle','--')
plot(data_out(:,1),abs(W_f2_back)/abs(W_f2_back(end))*in_data(T2,3)/in_data(T1,3),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(2,:) = get(gca,'YLim');
G2 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Ampl, 12.1kHz')

subplot(2,3,3)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,4)/in_data(T1,4),'color','b','linestyle','-')
plot(data_out(:,1),abs(W_f3_forw)/abs(W_f3_forw(1)),'color','b','linestyle','--')
plot(data_out(:,1),abs(W_f3_back)/abs(W_f3_back(end))*in_data(T2,4)/in_data(T1,4),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(3,:) = get(gca,'YLim');
G3 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Ampl, 13.6kHz')

subplot(2,3,4)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,5)-in_data(T1,5),'color','b','linestyle','-')
plot(data_out(:,1),(angle(W_f1_forw)-angle(W_f1_forw(1)))*10^(6)/(2*pi*10.2*10^(3)),'color','b','linestyle','--')
plot(data_out(:,1),(angle(W_f1_back)-angle(W_f1_back(end)))*10^(6)/(2*pi*10.2*10^(3))+in_data(T2,5)-in_data(T1,5),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(4,:) = get(gca,'YLim');
G4 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Phase, 10.2kHz')

subplot(2,3,5)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,6)-in_data(T1,6),'color','b','linestyle','-')
plot(data_out(:,1),(angle(W_f2_forw)-angle(W_f2_forw(1)))*10^(6)/(2*pi*10.2*10^(3)),'color','b','linestyle','--')
plot(data_out(:,1),(angle(W_f2_back)-angle(W_f2_back(end)))*10^(6)/(2*pi*10.2*10^(3))+in_data(T2,6)-in_data(T1,6),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(5,:) = get(gca,'YLim');
G5 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Phase, 12.1kHz')

subplot(2,3,6)
hold on
plot(in_data(T1:T2,1),in_data(T1:T2,7)-in_data(T1,7),'color','b','linestyle','-')
plot(data_out(:,1),(angle(W_f3_forw)-angle(W_f3_forw(1)))*10^(6)/(2*pi*10.2*10^(3)),'color','b','linestyle','--')
plot(data_out(:,1),(angle(W_f3_back)-angle(W_f3_back(end)))*10^(6)/(2*pi*10.2*10^(3))+in_data(T2,7)-in_data(T1,7),'color','r','linestyle','--')
xlim([data_out(1,1) data_out(end,1)])
YLim(6,:) = get(gca,'YLim');
G6 = gca;
switch units
    case 1
        XTick = fix(data_out(1,1)*24):1:fix(data_out(end,1)*24);
        set(gca,'Xtick',XTick./24,'XTickLabel',datestr(XTick./24,'HH'))
    case 2
        
end
grid on
xlabel('UT, hours')
ylabel('Phase, 13.6kHz')

ylim1 = [min(YLim(1:3,1)) max(YLim(1:3,2))];
ylim2 = [min(YLim(4:6,1)) max(YLim(4:6,2))];
set(G1,'YLim',ylim1)
set(G2,'YLim',ylim1)
set(G3,'YLim',ylim1)
set(G4,'YLim',ylim2)
set(G5,'YLim',ylim2)
set(G6,'YLim',ylim2)

end