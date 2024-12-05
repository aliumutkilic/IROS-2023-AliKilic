function out = fn_objective(u,p)

dt  = p.dt;
out = 0.5*sum(sum(u.^2))*dt;