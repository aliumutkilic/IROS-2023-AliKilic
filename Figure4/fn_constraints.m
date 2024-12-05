function [c_ineq,c_eq] = fn_constraints(u,p)

x0       = p.x0;                % initial conditions
x        = ode_solver(x0,u,p);  % states
x1       = p.x1;
bc_error = x(end,:)'-x1;        % boundary conditions
c_eq     = bc_error;            % equality constraints
c_ineq   = [];                  % inequality constraints