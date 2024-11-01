function[c_ineq, c_eq] = fn_linear_constraint(param,p)

global x_0 xdot_0 y_0 ydot_0 p1;

%% Parameters
m  = p.m;
g  = p.g;
r0 = p.l0;

%% Time

t_start = 0;            %%%Starting time = 0s
t_end = 10;             %%%Ending time (s)
options1 = odeset('Events',@linear_pause_event,'AbsTol',1e-8); %%Pause at midstep
options2 = odeset('Events',@linear_end_event,'AbsTol',1e-8);   %%End at toe-off
dt = 0.001;                                 %Time step (s)
n = (t_end-t_start)/dt;                 %Time vector length
tspan = linspace(t_start,t_end,n);      %Simulation time for each step

%% Convert from cartesian to polar

l = sqrt(x_0^2+y_0^2);
initial_angle = atan(x_0/y_0);
rdot_initial = (x_0*xdot_0+y_0*ydot_0)/sqrt(x_0^2+y_0^2);
thetadot_initial = (y_0*xdot_0-ydot_0*x_0)/(x_0^2+y_0^2);

p1 = m*l^2*thetadot_initial;
init_cond1 = [l;rdot_initial;initial_angle;thetadot_initial]; 

%% Starting initial conditions - between heelstrike and midstep

k1 = param(1);
k2 = param(2);

%% ODE Solver - between heelstrike and midstep

[t,z] = ode45(@(t,z) fn_linear_slip(t,z,k1,p), tspan, init_cond1,options1);

%% Initial conditions update - between midsep and toe-off

init_cond2 = [z(end,1);z(end,2);z(end,3);z(end,4)]; 
[t2,z2] = ode45(@(t2,z2) fn_linear_slip(t2,z2,k2,p), tspan, init_cond2,options2);

%% Convert back to cartesian

rad_vel = vertcat(z(1:end,2),z2(1:end,2));
ang_vel = vertcat(z(1:end,4),z2(1:end,4));

angle = vertcat(z(1:end,3),z2(1:end,3));
radi  = vertcat(z(1:end,1),z2(1:end,1));

hor_vel  = (rad_vel.*sin(angle)+ang_vel.*radi.*cos(angle));
vert_vel = rad_vel.*cos(angle)-radi.*ang_vel.*sin(angle);

x_pos1 = radi.*sin(angle);
y_pos1 = radi.*cos(angle);

epsilon = 0.3;

%% Constraints

c_eq   = [vert_vel(end)+epsilon];
c_ineq = [k2-k1];

end