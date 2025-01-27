
%Design space exploration.
%This code plots the curves representing number of days above 55°C
%Comparison between F:SD ratio and (Qa) at 2x stoichiometric demand
%Evaluation at 7 kg and 15 kg
%Values obtained with excel sheet "OperationalSpace"

%Initialization:
Hc = [17.500 17.500 17.500 17.500 17.500];  %Heat of combustion fixed
a = [0.10 0.10 0.10 0.10 0.10];             %k correction parameter 'a'
%Rt = [0.081 0.081 0.081 0.081 0.081];       %Thermal resistance for 7kg
Rt = [0.076 0.076 0.076 0.076 0.076];       %Thermal resistance for 15kg
%m = [7 7 7 7 7];                            %total compost mass 7kg
m = [15 15 15 15 15];                       %total compost mass 15kg
T0 = 24;                                    %Initial Temperature (°C) 

%BVS = [0.774 0.801 0.845 0.881 0.896];      %BVS at different CN ratios 7kg
BVS = [1.658 1.714 1.809 1.885 1.917];      %BVS at different CN ratios 15kg
cm = [2.92 2.81 2.67 2.54 2.47];            %Specific heat at CN ratios
%Q = [0.85 1.34 1.82 2.31 2.79];             %Air flowrate at min stoic. demand
%Q = [1.7 2.68 3.64 4.62 5.58];              %Air flowrate at 2x stoic. demand
Q = [3.40 5.36 7.28 9.24 11.16];            %Air flowrate at 2x for 15kg

P = [Hc; m; Rt; a; cm; BVS];           %Variable parameters [Hc,m,Rt,a,cm,BVS]                    
hr = linspace(0,6,577);                %6,577 means 144 test hours, 6 days.

%Evaluate for each column of the variable parameters:
for j = 1:1:5 
    C = BVS(j);           %BVS fraction dry mass (kg)
    Y0 = [C,T0];          %ODE initial values
    
    %Solve ODE:
    for i = 1:1:5         %Run the model at each of the 5 values for Q
        [tSol,YSol] = ode45(@(t,Y)thermalbalanceODE(t,Y,Q(i),P(:,j)),hr,Y0);
        tempSol = YSol(:,2);
        curves(:,i) = tempSol;
        days = countDays(curves,i)          %Number of days above 55°C
        da5d(i,j) = days(i)                 %Array of days above 55°C
    end
end

%Plot surface---
f=figure;
fs=20;
map = [ 0.9490    0.674    0.635
        0.7314    0.6235    0.9990
        0.6510    0.7333    0.9686
        0.6549    0.8235    0.9176
        0.6627    0.9137    0.8706
        0.6706    1.0000    0.8157];

%surfc(da5d)
[M,c] = contourf(da5d,[1 2 3 4 5],'ShowText','on',"FaceAlpha",0.7,LabelSpacing=500);
c.LineWidth = 3;

xticks([1 2 3 4 5])
yticks([1 2 3 4 5])
xticklabels({'1:2.0','1:2.5','1:3.5','1:4.5','1:5.0'})  %F:SD ratio
%yticklabels({'0.85','1.34','1.82','2.31','2.79'})       %Airflow rate
%yticklabels({'1.7','2.68','3.64','4.62','5.58'})        %Airflow rate 2x
yticklabels({'3.40','5.36','7.28','9.24','11.16'})      %Airflow rate 2x 15kg
xlabel('Feces to sawdust ratio (F:SD)');
ylabel('Air flow rate (kg/day)');
zlabel('Days above 55°C');
colormap(map)
clim([1 5])
grid on
ax = gca;
ax.FontSize = fs;
fontname(f,'times')

%Function to count 3 days above 55°C:
function days = countDays(curves,i)
    for c = 1:i                 %Index for the curves evaluated
        m = 0;                  %Reset marker
       for r = 1:length(curves) %Array index
          v = curves(r,c);     %Temperature value at that index
         if v >= 55
             m = m+1;         %Marker to count # of values above 55°C
         end
       end
    days(c) = m/4/24;           %Calculate # of days above 55°C and store in array
    end
end

%Differential equation:
function dYdt = thermalbalanceODE(t,Y,Q,P)
    
    %Parameters:
    C = Y(1);
    T = Y(2);
    
    Qa = Q;             %Mass flow rate air (kg/day)
    Hc = P(1)*1000;     %Heat of combustion (kJ/kg) 
    m = P(2);           %Compost mass (kg)
    Rt = P(3);          %Thermal resistance insulation (°C·day/kJ) 
    a = P(4);            
    cm = P(5);          %Specific heat compost mix (kJ/kg°C)

    %Constants:
    n = 1;              %reaction order (>=1)
    b = 0.1;            %0.1
    Ta = 24;            %Ambient Temperature (°C)
    ca = 1.006; %       %Specific heat dry air (kJ/kg°C)
    cv = 1.860; %       %Specific heat water vapor (kJ/kg°C)
    Lv = 2501;  %       %latent heat of evaporation (kJ/kg) 
      
    %Correction functions:
    k = a*exp(-b*((T-70)/35)^2);        %Temperature correction     
    %Energy loss equations (kJ/day):
    vi = 0.5*(0.00464*exp(0.05859*Ta)); %Humidity Ratio inlet
    vo = 0.00464*exp(0.05859*T);        %Humidity Ratio outlet
    Ea = Qa*(((ca+(vi*cv))*(T-Ta)) + (Lv*(vo-vi)));
    Ec = ((T-Ta)/Rt);                   
    %Complete Energy Balance:
    dCdt = -k*(C^n);
    dTdt = ((-Hc*dCdt) - Ea - Ec ) / (m*cm) ;
    dYdt = [dCdt;dTdt];
end

%-


