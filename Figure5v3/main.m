clc;
clear;
close all;

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

xdot_hs = zeros(1,21);
ydot_hs = zeros(1,21);

%% ODE Options

options1 = odeset('Events',@pausevent,'AbsTol',1e-5);  %Pauses upon reaching midstep
options2 = odeset('Events',@endevent,'AbsTol',1e-5);   %Pauses upon reaching toe-off

%% Simulation Starting Parameters

x_0       = -0.05;                              %TD horizontal position (m)
xdot_0    = 3;                                  %TD horizontal velocity (m/s)
ydot_0    = -0.6;                               %TD vertical velocity (m/s)
y_0       = y_td;

init_cond = [x_0;xdot_0;y_0;ydot_0];

xdot_desired = 1.2*sqrt(g*l0);

%% Values to be Plotted and Recorded

xdot_vector = [];
ydot_vector = [];
x_vector    = [];
y_vector    = [];
ydot_end    = [ydot_0];
xdot_end    = [xdot_0];
foot_vector = [];
start_step = [];
end_step = [];
%% Controller gains

% original gains
% gain1 = 1005;
% gain2 = 5650;

% new gains
gain1 = 1000;
gain2 = 5500;

%% Walking Loop

for i = 1:30
    
stepping_policy(i) = x_0/x_max;

% original (not as in the paper) - this works
k1ss = (pi/x_max)*(m*g)*((x_max-x_0)-(xdot_0*ydot_0/g))/( (l0-y_0) * (pi*sin(0.5*pi*x_0/x_max)^2-sin(pi*x_0/x_max)-pi*(x_0/x_max)) );
k1   = k1ss - gain1 * init_cond(4) ;
k2ss = 0.5*k1*(1-cos(pi*x_0/x_max));
k2   = k2ss + gain2 * (xdot_desired - init_cond(2));

% new 1 (as in the paper) - this also works
% k1ss = (pi/x_max)*(m*g)*((x_max-x_0)-(xdot_0*ydot_0/g))/( (l0-y_0) * (pi*sin(0.5*pi*x_0/x_max)^2-sin(pi*x_0/x_max)-pi*(x_0/x_max)) );
% k2ss = 0.5*k1ss*(1-cos(pi*x_0/x_max));
% k1 = k1ss - gain1 * init_cond(4) ;
% k2 = k2ss + gain2 * (xdot_desired-init_cond(2));

% currently not in the paper
if k2 >= k1 
   %k2  = k1;
end

%% Until Mid - Step

[t,z] = ode45(@(t,z)fn_slip_ode(t,z,k1,p),tspan,init_cond,options1);

%% Record Pos
if i ==1
   x_vector = vertcat(x_vector,z(1:end,1));
   foot_vector(i) = 0;
   start_step(i) = x_0;
   start_step_y(i) = y_0;
else
   foot_vector(i) = x_vector(end)-x_0;
   start_step(i) = x_vector(end);
   start_step_y(i) = y_vector(end);
   x_vector = vertcat(x_vector,z(1:end,1)+x_vector(end)-x_0);
   

end

y_vector    = vertcat(y_vector,z(1:end,3));

xdot_vector = vertcat(xdot_vector,z(1:end,2));
ydot_vector = vertcat(ydot_vector,z(1:end,4));

%% After Midstep
mid_step_x(i) = x_vector(end);
mid_step_y(i) = y_vector(end);
init_cond = [z(end,1);z(end,2);z(end,3);z(end,4)];
[t2,z2]   = ode45(@(t2,z2)fn_slip_ode(t2,z2,k2,p),tspan,init_cond,options2);

%plot(z2(1:end,1),z2(1:end,3),'Color',[68/255 169/255 166/255],'LineWidth',2);
%hold on;

%% Record

x_vector = vertcat(x_vector,z2(1:end,1)+x_vector(end));
y_vector = vertcat(y_vector,z2(1:end,3));

xdot_vector = vertcat(xdot_vector,z2(1:end,2));
ydot_vector = vertcat(ydot_vector,z2(1:end,4));

%% Clear ODE Time and Data
clear t z t2 z2;

%% Stepping Control

x_0 = x_0 - lambda*(x_0+x_max);

%% Update for Next Step

%init_cond = [x_0,xdot_vector(end),y_vector(end),ydot_vector(end)]; % previously this was a column vector
init_cond     = [x_0;xdot_vector(end);y_vector(end);ydot_vector(end)]; % previously this was a column vector
x_max         = sqrt(l0^2 - y_vector(end)^2);

ydot_end(i+1) = init_cond(4);
xdot_end(i+1) = init_cond(2);

stiffness_ratio(i) = k2/k1;
end_step(i) = x_vector(end);
end

xdot_0_dimensionless = xdot_0/sqrt(g*l0);
ydot_0_dimensionless = ydot_0/sqrt(g*l0);

xdot_end_dimensionless = xdot_end/sqrt(g*l0);
ydot_end_dimensionless = ydot_end/sqrt(g*l0);

save data_approximate_SLIP

plots