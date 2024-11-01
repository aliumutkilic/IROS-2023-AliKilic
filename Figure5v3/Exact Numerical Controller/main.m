clc
clear
close all

global x_0 xdot_0 y_0 ydot_0 x_max

%% Raw Parameters

p = parameters();

m  = p.m;
l0 = p.l0;
g  = p.g;

step_number = p.step_number;
x_max       = p.x_max;
lambda      = 0.2;

%% Derived Parameters

y_td = sqrt(l0^2-x_max^2);                  %Touchdown Vertical Position (m)

%% Simulation Time

t_initial = 0;                              %Sim start time (s)
t_final   = 10;                             %Sim end time (s)
dt        = 0.001;                          %Time step (s)
n         = (t_final-t_initial)/dt;         %Time vector length
tspan     = linspace(t_initial,t_final,n);  %Simulation time for each step

%% Array Preallocation

stiffness_ratio = zeros(1,21);
stepping_policy = zeros(1,21);
xdot_hs         = zeros(1,21);
ydot_hs         = zeros(1,21);

%% ODE Options

options1 = odeset('Events',@pausevent,'AbsTol',1e-8,'RelTol',1e-8);        %Pauses upon reaching midstep
options2 = odeset('Events',@endevent,'AbsTol',1e-8,'RelTol',1e-8);         %Pauses upon reaching toe-off

%% Optimization Options

TolX    = 10^(-12);
TolFun  = 10^(-12);
TolCon  = 10^(-12);
maxIter = 10000;
options_optim = optimset('Display','iter','TolFun',TolFun,'TolX',TolX,'TolCon',TolCon,'MaxFunEvals',1000*maxIter,'MaxIter',maxIter,'Algorithm','sqp');
lb     = [0,0];                     %%% Lower bound for stiffness (N/m)
ub     = [10000000,10000000];       %%% Upper bound for stiffness (N/m)
param0 = [0,0];                     %%% Initial choice of stiffness arbitrary (N/m)

%% Simulation Starting Parameters
x_0       = -0.05;                             %TD horizontal position (m)
xdot_0    = 3;                                 %TD horizontal velocity (m/s)
ydot_0    = -0.6;                              %TD vertical velocity (m/s)
y_0       = y_td;
init_cond = [x_0;xdot_0;y_0;ydot_0];

%% Values to be Plotted and Recorded

xdot_vector = [];
ydot_vector = [];
x_vector    = [];
y_vector    = [];
ydot_end    = [ydot_0];
xdot_end    = [xdot_0];

for i = 1:step_number

stepping_policy(i) = x_0/x_max;

%% Optimization

param1 = fmincon(@(param)fn_objective(param,p),param0,[],[],[],[],lb,ub,@(param)fn_constraint_func(param,p),options_optim);

k1 = param1(1);
k2 = param1(2);

[t,z] = ode45(@(t,z) fn_slip_ode(t,z,k1,p),tspan,init_cond,options1);

%% Record Pos

if i ==1
x_vector = vertcat(x_vector,z(1:end,1));
else
x_vector = vertcat(x_vector,z(1:end,1)+x_vector(end)-x_0);
end

y_vector    = vertcat(y_vector,z(1:end,3));
xdot_vector = vertcat(xdot_vector,z(1:end,2));
ydot_vector = vertcat(ydot_vector,z(1:end,4));

%% After Midstep
init_cond = [z(end,1);z(end,2);z(end,3);z(end,4)];
[t2,z2] = ode45(@(t2,z2) fn_slip_ode(t2,z2,k2,p),tspan,init_cond,options2);

%% Record
x_vector = vertcat(x_vector,z2(1:end,1)+x_vector(end));
y_vector = vertcat(y_vector,z2(1:end,3));
xdot_vector = vertcat(xdot_vector,z2(1:end,2));
ydot_vector = vertcat(ydot_vector,z2(1:end,4));

%% Stepping Control
x_0 = x_0 - lambda*(x_0+x_max);
y_0 = z2(end,3);
xdot_0 = z2(end,2);
ydot_0 = z2(end,4);

%% Update for Next Step
init_cond = [x_0,xdot_0,y_0,ydot_0];
x_max = sqrt(l0^2 - y_vector(end)^2);
ydot_end(i+1) = init_cond(4);
xdot_end(i+1) = init_cond(2);
stiffness_ratio(i) = k2/k1;

%% Clear ODE Time and Data
clear t z t2 z2;
param0 = [param1(1),param1(2)];

end

plot(ydot_vector)
xlabel('Data Point');
ylabel('Vertical Velocity (m/s)')
figure;
plot(xdot_vector);
xlabel('Data Point');
ylabel('Horizontal Velocity (m/s)')
figure;
scatter(1:1:i+1,ydot_end/sqrt(g))
ylim([-0.4,0.4])

xlabel('Step Number');
ylabel('HS Vertical velocity (m/s)')
figure;
scatter(1:1:i+1,xdot_end/sqrt(g))
xlabel('Step Number');
ylabel('HS Horizontal velocity (m/s)')
figure;
scatter(1:1:i,stepping_policy)
xlabel('Step Number');
ylabel('x_{hs}/x_{td}')
figure;
scatter(1:1:i,stiffness_ratio)
xlabel('Step Number');
ylabel('k_2/k_1')
figure;
plot(x_vector,y_vector);
ylim([0,1]);
xdot_0_dimensionless = xdot_0/sqrt(g*l0);
ydot_0_dimensionless = ydot_0/sqrt(g*l0);

xdot_end_dimensionless = xdot_end/sqrt(g*l0);
ydot_end_dimensionless = ydot_end/sqrt(g*l0);

save data_exact_SLIP
