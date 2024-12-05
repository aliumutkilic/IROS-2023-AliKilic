function dxdt = fn_differential_equation(t,x,u,p)

beta   = p.beta;
gamma  = p.gamma;

u_magnet = fn_sum_of_basis_functions(x(1),p);
 
dxdt   = [x(2)
         -beta*x(2)+gamma*(u+u_magnet)];