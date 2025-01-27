
% Code to plot various curves for simulations
% Comparison of Volume effects 

%Read data: 
T1a = readtable("Exp1.csv").cn25; % container A, CN:25 
T1b = readtable("Exp1.csv").cn30; % container B, CN:30
T1c = readtable("Exp1.csv").cn35; % container C, CN:35
T2a = readtable("Exp2a.csv").mc50; % container A, MC:50 
T2b = readtable("Exp2a.csv").mc60; % container B, MC:60
T2c = readtable("Exp2a.csv").mc70; % container C, MC:70
Tfb = readtable("Exp2b.csv").bot; % temp bottom 
Tfm = readtable("Exp2b.csv").mid; % temp mid
Tft = readtable("Exp2b.csv").top; % temp top
Thb = readtable("Exp2c.csv").bot; % temp bottom 
Thm = readtable("Exp2c.csv").mid; % temp mid
Tht = readtable("Exp2c.csv").top; % temp top
curves(:,1) = readtable("SimResFig6_6.csv").cn35;
curves(:,2) = readtable("SimResFig6_6.csv").mc50;
curves(:,3) = readtable("SimResFig6_6.csv").expA;
curves(:,4) = readtable("SimResFig6_6.csv").expB;
hr = linspace(0,6,577);

%Plot results---
f=figure;
fs=20;

subplot(2,2,1);
plot(hr,curves(:,1),'k-',hr,T1c,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Model','CN35','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
title("(a)",'fontsize',fs)
fontname(f,'times')

subplot(2,2,2);
plot(hr,curves(:,2),'k-',hr,T2a,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Model','MC50','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
title("(b)",'fontsize',fs)
fontname(f,'times')

subplot(2,2,3);
plot(hr,curves(:,3),'k-',hr,Tft,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Model','Exp. A','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
title("(c)",'fontsize',fs)
fontname(f,'times')

subplot(2,2,4);
plot(hr,curves(:,4),'k-',hr,Thm,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Model','Exp. B','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
title("(d)",'fontsize',fs)
fontname(f,'times')









