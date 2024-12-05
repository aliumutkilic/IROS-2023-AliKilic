%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimal Design
% Author: David Braun
% Last modified: Sept 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

background = 1*[1,1,1];
whitebg(background);

%% Options for the NLP solver
TolX    = 10^(-6);
TolFun  = 10^(-6);
TolCon  = 10^(-6);
maxIter = 1000;
options = optimset('Display','iter','TolFun',TolFun,'TolX',TolX,'TolCon',TolCon,'MaxFunEvals',100*maxIter,'MaxIter',maxIter,'Algorithm','sqp');

%% Model parameters
p  = parameters();
 p2 = p;
% p3 = p;
 p2.x0 = [p.x1(1);0];
 p2.x1 = [p.x0(1);0];
% p3.x0 = [-pi/2;0];
% p3.x1 = [pi/2;0];
%% Initial guess for the controls
t     =  p.t;
dim_t =  length(t);
dim_u = [dim_t-1,1];
u0    = 0.1*ones(dim_u); % must be consistent with the constraints

%% Bound constraints on the controls
u_min = -0.2*ones(dim_u); 
u_max = +0.2*ones(dim_u);

%% Optimization - NLP solver: fmincon or alternative
objective   = @(u)fn_objective(u,p);
constraints = @(u)fn_constraints(u,p);
u           = fmincon(objective,u0,[],[],[],[],u_min,u_max,constraints,options);
objective2   = @(uu)fn_objective(uu,p2);
constraints2 = @(uu)fn_constraints(uu,p2);
uu           = fmincon(objective2,u0,[],[],[],[],u_min,u_max,constraints2,options);
% objective3   = @(uuu)fn_objective(uuu,p3);
% constraints3 = @(uuu)fn_constraints(uuu,p3);
% uuu           = fmincon(objective3,u0,[],[],[],[],u_min,u_max,constraints3,options);
%% Optimal state trajectories
x0  = p.x0;               % initial condition
x   = ode_solver(x0,u,p); % state trajectories
x02 = p2.x0;
xx = ode_solver(x02,uu,p2);
% x03 = p3.x0;
% xx1 = ode_solver(x03,uuu,p3);
%% Plots
tau_motor = [u(:,1);u(end,1)];
tau_motor2 = [uu(:,1);uu(end,1)];
%tau_motor2 = [uu(:,1);uu(end,1)];
for i = 1:length(t)
tau_magnet(i,1) = fn_sum_of_basis_functions(x(i,1),p);
tau_total(i,1)  = tau_motor(i,1) + tau_magnet(i,1);
end
for j = 1:length(t)
tau_magnet2(j,1) = fn_sum_of_basis_functions(xx(j,1),p2);
tau_total2(j,1)  = tau_motor2(j,1) + tau_magnet2(j,1);
end
%% Decomposition
for i=1:length(t)
sum_of_basis_functions(i,1) = fn_sum_of_basis_functions(x(i,1),p);
for j=1:p.n
basis_functions(i,j) = fn_basis_function(x(i,1),p,j);
end
end
x_traj = vertcat(x,xx,x);
t_traj = horzcat(t,t+t(end),t+2*t(end));
tau_traj = vertcat(tau_total,tau_total2,tau_total);
taumag = vertcat(tau_magnet,tau_magnet2,tau_magnet);
%%
save data

%%
plots