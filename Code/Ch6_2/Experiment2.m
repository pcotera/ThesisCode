
% Code to plot experimental results from Exp2
% Change in MC and expA and expB  

%Read data: 
Ta = readtable("Exp2a.csv").mc50; % container A, MC:50 
Tb = readtable("Exp2a.csv").mc60; % container B, MC:60
Tc = readtable("Exp2a.csv").mc70; % container C, MC:70
Tfb = readtable("Exp2b.csv").bot; % temp bottom 
Tfm = readtable("Exp2b.csv").mid; % temp mid
Tft = readtable("Exp2b.csv").top; % temp top
Thb = readtable("Exp2c.csv").bot; % temp bottom 
Thm = readtable("Exp2c.csv").mid; % temp mid
Tht = readtable("Exp2c.csv").top; % temp top
hr = linspace(0,6,577);

%Plot results---
f=figure;
fs=20;

subplot(1,3,1);
plot(hr,Ta,':',hr,Tb,'-.',hr,Tc,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('MC50','MC60','MC70','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
fontname(f,'times')
title("(a)",'fontsize',fs)
%title("Exp. 2 different MC (0.95kg)",'fontsize',fs)

subplot(1,3,2);
plot(hr,Tft,':',hr,Tfm,'-.',hr,Tfb,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Top','Mid','Bottom','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
fontname(f,'times')
title("(b)",'fontsize',fs)
%title("Exp. 'A' different depths (2.4kg)",'fontsize',fs)

subplot(1,3,3);
plot(hr,Tht,':',hr,Thm,'-.',hr,Thb,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Top','Mid','Bottom','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
fontname(f,'times')
title("(c)",'fontsize',fs)
%title("Exp. 'B' different depths (5.1kg)",'fontsize',fs)

