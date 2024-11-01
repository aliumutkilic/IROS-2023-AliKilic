function cost = fn_linear_objective(param,p)

global x_0 xdot_0 y_0 ydot_0 p1;

m  = p.m;
g  = p.g;
r0 = p.l0;

%% Simulation Options and Parameters

t_start = 0;            %%%Starting time = 0s
t_end = 10;             %%%Ending time (s)
options1 = odeset('Events',@linear_pause_event,'AbsTol',1e-8,'RelTol',1e-8); %%Pause at midstep
options2 = odeset('Events',@linear_end_event,'AbsTol',1e-8,'RelTol',1e-8);   %%End at toe-off
dt = 0.001;                                 %Time step (s)
n = (t_end-t_start)/dt;                 %Time vector length
tspan = linspace(t_start,t_end,n);      %Simulation time for each step

%% Convert from cartesian to polar
l = sqrt(x_0^2+y_0^2);

initial_angle = atan(x_0/y_0);

rdot_initial = (x_0*xdot_0+y_0*ydot_0)/sqrt(x_0^2+y_0^2);

thetadot_initial = (y_0*xdot_0-ydot_0*x_0)/(x_0^2+y_0^2);

p1 = m*l^2*thetadot_initial;

%% Starting initial conditions - between heelstrike and midstep

init_cond1 = [l;rdot_initial;initial_angle;thetadot_initial];  

%% Stiffnesses

k1 = param(1);
k2 = param(2);

%% ODE Solver - between heelstrike and midstep

[t,z] = ode45(@(t,z)fn_linear_slip(t,z,k1,p), tspan, init_cond1,options1);

%% Initial conditions update - between midsep and toe-off

init_cond2 = [z(end,1);z(end,2);z(end,3);z(end,4)]; 
[t2,z2] = ode45(@(t2,z2) fn_linear_slip(t2,z2,k2,p), tspan, init_cond2,options2);

%% Convert back to Cartesian

rad_vel = vertcat(z(1:end,2),z2(1:end,2));
ang_vel = vertcat(z(1:end,4),z2(1:end,4));

angle = vertcat(z(1:end,3),z2(1:end,3));
radi  = vertcat(z(1:end,1),z2(1:end,1));

hor_vel = (rad_vel.*sin(angle)+ang_vel.*radi.*cos(angle));
vert_vel = rad_vel.*cos(angle)-radi.*ang_vel.*sin(angle);

x_pos = radi.*sin(angle);
y_pos = radi.*cos(angle);

%% Calculate cost

%cost =   100000*(1.2*sqrt(g)-z2(end,2))^2 + 100*(z2(end,4))^2;
cost =   100*(hor_vel(1)-hor_vel(end))^2 ;

end