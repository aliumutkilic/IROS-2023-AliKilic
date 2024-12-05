function  p = parameters()

j  = 3.5*10^-3; % inertia
b  = 2.27*10^-5; % damping

T  = 0.5;        % terminal time
nt = 101;        % # of discrete time points
dt = T/(nt-1);   % time increment
t  = 0:dt:T;     % time

x0 = [deg2rad(-60);0];  % initial conditions
x1 = [deg2rad(60);0];   % boundary conditions

n     = 5;       % # of magnet sets - this can be 1 3 5 9
%n     = 6;

xmin  = -pi/2;
xmax  =  pi/2;
% xmin  = 0;
% xmax  = pi/2;


%a     = 0.02*ones(n,1);              % amplitude
%a     = [0.02; 0.06; -0.04; 0.06; 0.02];
%a     = [-0.02; 0.04; -0.02];         % good design
%a     = [-0.04; 0.04; 0.02;0.04; -0.04];        % good design
%a     = 2*[-0.04; -0.03; -0.02; -0.03;-0.04];        % best design
%a     = [-0.04; 0.03; 0.02; 0.02; 0.03; -0.04];
%a     = -[-0.03; -0.01; 0.05; -0.01;-0.03]; % experimental configuration figure 5(2/26/24)
%a     = 2*[0.03; 0.02; -0.04; 0.02;0.03]; % experimental configuration (2/26/24)
a     = -[0.103; -0.015; -0.086; -0.015;0.103];
c     = [0:1/(n-1):1]';               % center
c     = xmin + c*(xmax-xmin);

w     = ones(n,1)*(xmax-xmin)/(5);   % width ? change this

coeff = [a,c,w];

p.n      = n;
p.beta   = b/j;
p.gamma  = 1/j;
p.x0     = x0;
p.x1     = x1;
p.nt     = nt;
p.dt     = dt;
p.t      = t;
p.coeff  = coeff;
