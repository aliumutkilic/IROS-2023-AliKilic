function sdot = fn_linear_slip(t,s,param,p)

global p1;

sdot = zeros(4,1);
l0   = p.l0;
g    = p.g;
m    = p.m;

k    = param;

rho     = (s(1)-l0)/l0;
w       = p1/(m*l0^2);
thd1    = w*(1-2*rho);           % Geyer (2.17)
thd2    = w*(1-2*rho+3*rho^2);   % Geyer (2.9)

sdot(1) = s(2);
sdot(2) = (k*(l0-s(1))-m*g+m*s(1)*thd2^2)/m;
sdot(3) = s(4);
sdot(4) = (g*s(1)*s(3)-2*s(1)*s(2)*thd1)/(s(1)^2);

end