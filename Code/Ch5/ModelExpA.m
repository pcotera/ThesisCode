
% Solving first order ODE
% Degradation kinetics equation using BVS fraction
% Simulation for calibrating ExpA results. 
% Used to plot Figure 5.2

%Read data: 
Tf = readtable("ExpA5.csv").tav; % 5,481

%Initialization:
C = 0.269;                      %BVS fraction dry mass (kg)
T0 = 24;                        %Initial Temperature (°C)
Y0 = [C,T0];                    %ODE initial values
tRange = linspace(0,5,481); 

%Solve ODE:
[tSol,YSol] = ode45(@thermalbalanceODE,tRange,Y0);
concSol = YSol(:,1);
tempSol = YSol(:,2);
massDegraded = Y0(1)-concSol(end);
maxTemp = max(tempSol);
t5m = tempSol*.95;
t5p = tempSol*1.05;

%Plot results---
f=figure;
fs=18;
plot(tRange,Tf,"o",tRange,tempSol,'k',tRange,t5m,"-.",tRange,t5p,"--",'LineWidth',2,'MarkerSize',4,'MarkerEdgeColor',[0.75,0.75,0.75])
ylim([20 70])
yticks(20:5:70)
grid on
ax = gca;
ax.FontSize = fs; 
legend('Experiment Data','Thermal Model','Model -5%','Model +5%','fontsize',fs)
xlabel 'Time (days)'
ylabel 'Temperature (°C)'
fontname(f,'times')

%Differential equation:
function dYdt = thermalbalanceODE(~,Y,P)
    C = Y(1);
    T = Y(2);

    %Parameters:
    n = 1;             %reaction order (>=1)
    a = 0.2;           %Rate constant <1
    b = 0.1;           
    
    CN = 22;
    w = 57;
    Qa = 1.79;          %Mass flow rate air (kg/day) 
    m = 2.43;           %Compost mass (kg)
    cm = 2.87;          %Specific heat compost mix (kJ/kg°C)
    Rt = 0.074;         %Thermal resistance insulation (°C·day/kJ) 
   
    ca = 1.006; %       %Specific heat dry air (kJ/kg°C)
    cv = 1.860; %       %Specific heat water vapor (kJ/kg°C)
    Lv = 2501;  %       %latent heat of evaporation (kJ/kg) 
    Ta = 24;    %       %Ambient Temperature (°C)
    Hc = 17500; %       %Heat of combustion (kJ/kg) 
     
    %Correction functions:
    kt = a*exp(-b*(((T-70)/35))^2);      %Temperature correction 
    kw = exp(-0.5*((w-55)/27.5)^2);
    kcn = exp(-0.4*((CN-20)/7)); 
    k = kt*kw*kcn;                       %Total rate constant (1/day)
    
    %Energy loss equations (kJ/day):
    vi = 0.5*(0.00464*exp(0.05859*Ta)); %Humidity Ratio inlet
    vo = 0.00464*exp(0.05859*T);        %Humidity Ratio outlet
    Ea = Qa*(((ca+(vi*cv))*(T-Ta)) + (Lv*(vo-vi)));
    Ec = ((T-Ta)/Rt);                   %Conductive losses container wall

    %Complete Energy Balance:
    dCdt = -k*(C^n);
    dTdt = ((-Hc*dCdt) - Ea - Ec) / (m*cm) ;
    dYdt = [dCdt;dTdt];
end


