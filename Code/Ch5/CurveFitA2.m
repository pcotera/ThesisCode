
%Simple code for curve fitting

Th = readtable("ExpA5.csv").tav; % 5,481

%Initialization:
C = 0.269;                      %BVS fraction dry mass (kg)
T0 = 24;                        %Initial Temperature (°C)
Y0 = [C,T0];                    %ODE initial values
hr = linspace(0,5,481); 

%Optimization problem---
prob = optimproblem("Description","Curve Fitting");
P = optimvar('P',2, "LowerBound",0.1,"UpperBound",0.99);
%Convert function to an optimization expression:
myfcn = fcn2optimexpr(@PtoODE,P,hr,Y0); 
prob.Objective = sum(sum((myfcn - Th).^2));
P0.P = [0.0 0.0]; %expected values for regression
[sol,sumsq] = solve(prob,P0)
disp(sol.P)
responsedata = evaluate(myfcn,sol);

%Plot results---
plot(hr,Th,"r.",hr,responsedata,'b',LineWidth=1.5)
legend('Experiment Data','Fitted Curve')
xlabel 'Time (days)'
ylabel 'Temperature (°C)'
title("Response Fitted to Experiment A")

%Differential equation:
function dYdt = thermalbalanceODE(~,Y,P)
    C = Y(1);
    T = Y(2);

    %Parameters:
    n = 1;              %reaction order (>=1)
    a = P(1);            
    b = P(2);            

    CN = 22;
    w = 57;
    m = 2.43;           %Compost mass (kg)
    cm = 2.873;         %Specific heat compost mix (kJ/kg°C)
    Qa = 1.79;           %Mass flow rate air (kg/day)
    Rt = 0.074;         %Thermal resistance insulation (°C·day/kJ) 0.074
    Ta = 24;            %Ambient Temperature (°C)
    
    ca = 1.006; %       %Specific heat dry air (kJ/kg°C)
    cv = 1.860; %       %Specific heat water vapor (kJ/kg°C)
    Lv = 2501;  %       %latent heat of evaporation (kJ/kg) 2501
    Hc = 17500; %       %Heat of combustion (kJ/kg) 17500
     
    %Correction functions:
    kt = a*exp(-b*(((T-70)/35))^2);   %Temperature correction 
    kw = exp(-0.5*((w-55)/27.5)^2);
    kcn = exp(-0.4*((CN-20)/7)); 
    k = kt*kw*kcn;                       %Total rate constant (1/day)
    
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

%Simple function that solves the ODE:
function tempSol = PtoODE(P,hr,Y0)
[tSol,YSol] = ode45(@(t,Y)thermalbalanceODE(t,Y,P),hr,Y0);
concSol = YSol(:,1);
tempSol = YSol(:,2);
massDegraded = Y0(1)-concSol(end);
end

%---