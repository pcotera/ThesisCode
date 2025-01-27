
% Code to plot experimental results from Exp1  

%Read data: 
Ta = readtable("Exp1.csv").cn25; % container A, CN:25 
Tb = readtable("Exp1.csv").cn30; % container B, CN:30
Tc = readtable("Exp1.csv").cn35; % container C, CN:35
hr = linspace(0,6,577);

%Plot results---
f=figure;
fs=20;
plot(hr,Ta,':',hr,Tb,'-.',hr,Tc,'--','LineWidth',3)
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('CN25','CN30','CN35','fontsize',fs)
xlabel('Time (days)','fontsize',fs)
ylabel('Temperature (°C)','fontsize',fs)
fontname(f,'times')
