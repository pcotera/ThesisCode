
%Simple code for modeling curves

Th = readtable("Exp2c.csv").tav; % 6,577

%Initialization:
C = 0.562;                      %BVS fraction dry mass (kg)
T0 = 24;                        %Initial Temperature (°C)
Y0 = [C,T0];                    %ODE initial values
hr = linspace(0,6,577); 

%Solve ODE:
[tSol,YSol] = ode45(@thermalbalanceODE,hr,Y0);
concSol = YSol(:,1);
tempSol = YSol(:,2);

%Plot results---
plot(hr,Th,"r.",hr,tempSol,'b',LineWidth=1.5)
legend('Experiment Data','Fitted Curve')
xlabel 'Time (days)'
ylabel 'Temperature (°C)'
title("Response Fitted to Experiment")

%Differential equation:
function dYdt = thermalbalanceODE(~,Y,P)
    C = Y(1);
    T = Y(2);

    %Parameters:
    n = 1;              %reaction order (>=1)
    a = 0.11;            
    b = 0.1;            

    m = 5.1;           %Compost mass (kg)
    cm = 2.78;         %Specific heat compost mix (kJ/kg°C)
    Qa = 0.85;           %Mass flow rate air (kg/day)
    Rt = 0.077;         %Thermal resistance insulation (°C·day/kJ) 0.074
    Ta = 24;            %Ambient Temperature (°C)
    
    ca = 1.006; %       %Specific heat dry air (kJ/kg°C)
    cv = 1.860; %       %Specific heat water vapor (kJ/kg°C)
    Lv = 2501;  %       %latent heat of evaporation (kJ/kg) 2501
    Hc = 17500; %       %Heat of combustion (kJ/kg) 17500
     
    %Correction functions:
    kt = a*exp(-b*((T-70)/35)^2);   %Temperature correction 
    k = kt;                        %Total rate constant (1/day)
    
    %Energy loss equations (kJ/day):
    vi = 0.5*(0.00464*exp(0.05859*Ta));             %Humidity Ratio inlet
    vo = 0.00464*exp(0.05859*T);                    %Humidity Ratio outlet
    Ea = Qa*(((ca+(vi*cv))*(T-Ta)) + (Lv*(vo-vi)));
    Ec = ((T-Ta)/Rt);                               %Conductive losses container wall

    %Complete Energy Balance:
    dCdt = -k*(C^n);
    dTdt = ((-Hc*dCdt) - Ea - Ec ) / (m*cm) ;
    dYdt = [dCdt;dTdt];
end


