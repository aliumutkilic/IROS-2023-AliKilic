function x = ode_solver(x0,u,p)

dt     = p.dt;
nt     = p.nt;
nx     = length(x0);
F      = zeros(nx,2);
X      = zeros(nx,nt);
X(:,1) = x0;

for i    = 1:nt-1
   ti    = i*dt;
   xi    = X(:,i);
   ui    = u(i,:)';
F(:,1)   = fn_differential_equation(ti,xi,ui,p);
F(:,2)   = fn_differential_equation(ti+dt,xi+dt*F(:,1),ui,p);
X(:,i+1) = xi + (dt/2)*(F(:,1) + F(:,2));
end
x = X.';