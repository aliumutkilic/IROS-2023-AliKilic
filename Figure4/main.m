clc;
clear;
close all;

global x_0 y_0 ydot_0 xdot_0 m g l0;

%% Optimization Options
TolX    = 10^(-6);
TolFun  = 10^(-6);
TolCon  = 10^(-6);
maxIter = 1000;
options_optim = optimset('Display','iter','TolFun',TolFun,'TolX',TolX,'TolCon',TolCon,'MaxFunEvals',1000*maxIter,'MaxIter',maxIter,'Algorithm','sqp');



%% Simulation Time
t_start = 0;                             %%%Starting time = 0s
t_end = 10;                              %%%Ending time (s)
dt = 0.001;                              %%%Time step (s)
n = (t_end-t_start)/dt;                  %%%Time vector length
tspan = linspace(t_start,t_end,n);       %%%Simulation time for each step

%% ODE Settings
options1 = odeset('Events',@pause_event,'AbsTol',1e-8,'RelTol',1e-8); %%Pause at midstep
options2 = odeset('Events',@end_event,'AbsTol',1e-8,'RelTol',1e-8);   %%End at toe-off

p = parameters();
x_max = p.x_max;
m= p.m;
g = p.g;
l0 = p.l0;



%% Fmincon Parameter Bounds
lb = [1,1];                             %%% Lower bound for stiffness (N/m)
ub = [100000,100000];                   %%% Upper bound for stiffness (N/m)
param0 = [5000,5000];                   %%% Initial choice of stiffness arbitrary (N/m)
param01 = [5000,4000];



%% Array Preallocation
x_hs = linspace(-0.599,-0.01,50);
y_0 = sqrt(1-x_max^2);
exact_ratio = zeros(1,length(x_hs));
approximate_ratio = zeros(1,length(x_hs));
xdot_matrix = linspace(1,2.5,2);
xdot_matrix = xdot_matrix*sqrt(9.81);
ydot_matrix = [];


%% Tested Velocity - Fast Walking
xdot_0 = 1.2*sqrt(g*l0);
ydot_0 = 0;
ydot_save = zeros(1,length(x_hs));


%% Loop
    for i = 1:length(x_hs)

        x_0 = x_hs(i);
        %% Approximate Analytical Ratio
        %approximate_ratio(i) = -((l0-sqrt(x_hs(i)^2+y_0^2)))^2 * (cos(pi*x_hs(i)/x_max) -1 ) / ((l0-y_0)^2 * (cos(pi*x_hs(i)/x_max)+1) );
        approximate_ratio(i) = 0.5*(1-cos(pi*x_hs(i)/x_max));

        %% Find Optimal Stiffnesses
        param1 = fmincon(@objfunc3,param0,[],[],[],[],lb,ub,@constraint_func5,options_optim);
  
        k1 = param1(1);
        k2 = param1(2);

        %% Exact Ratio
        exact_ratio(i) = k2/k1;

        %% Update Initial Guess for Optimization
        param0 = [k1,k2];
 
    end

%% Plot
figure(1);
   scatter(x_hs/x_max,exact_ratio,'MarkerFaceColor',[0 0.4470 0.7410]);
   hold on;
 plot(x_hs/x_max,approximate_ratio,'k');
 hold on;
 yticks([0 0.2 0.4 0.6 0.8 1])
 xticks([-1 -0.8 -0.6 -0.4 -0.2 0])
