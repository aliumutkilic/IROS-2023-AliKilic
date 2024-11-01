function cost = fn_objective(param,p)

global x_0 xdot_0 y_0 ydot_0

g  = p.g;
l0 = p.l0;

%% Simulation Options and Parameters

t_start = 0;              %%%Starting time = 0s
t_end   = 10;             %%%Ending time (s)
options1 = odeset('Events',@pausevent,'AbsTol',1e-8,'RelTol',1e-8); %%Pause at midstep
options2 = odeset('Events',@endevent,'AbsTol',1e-8,'RelTol',1e-8);   %%End at toe-off

dt = 0.001;                                 %Time step (s)
n = (t_end-t_start)/dt;                 %Time vector length
tspan = linspace(t_start,t_end,n);      %Simulation time for each step

%% Starting initial conditions - between heelstrike and midstep

init_cond1 = [x_0;xdot_0;y_0;ydot_0];       %%Initial conditions (x,xdot,y,ydot)
k1 = param(1);
k2 = param(2);

%% ODE Solver - between heelstrike and midstep

[t,z] = ode45(@(t,z) fn_slip_ode(t,z,k1,p), tspan, init_cond1,options1);

%% Initial conditions update - between midsep and toe-off

init_cond2 = [z(end,1);z(end,2);z(end,3);z(end,4)]; 
[t2,z2]    = ode45(@(t2,z2) fn_slip_ode(t2,z2,k2,p), tspan, init_cond2,options2);

%% Calculate cost

%cost =   100000*(1.2*sqrt(g)-z2(end,2))^2 + 100*(z2(end,4))^2;
cost =   100*(1.2*sqrt(g*l0)-z2(end,2))^2 ;

end