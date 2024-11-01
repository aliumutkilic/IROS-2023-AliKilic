clc;
clear all;
close all;

g = 9.81;
l0 = 1;
%% Values to be iterated
x_boundary = 0;
y_boundary = 0;
ytd = linspace(0.5,1,1000);
x_max1 = (1-ytd.^2).^0.5;
xdoths = 1.2*sqrt(g*l0);

%% Loop
for dd = 1:length(ytd)
x_max = x_max1(dd);
xtd = linspace(-1,0,1000);


for aa = 1:length(xtd)
x = linspace(xtd(aa),x_max-0.001,1000);
%% Original and Approx Forces
fy_original  = (ytd(dd)./sqrt(x.^2+ytd(dd)^2)) - ytd(dd);
fy_approximate  = 0.5*(1-ytd(dd))*(cos(pi*x./x_max)+1);
fx_original = (x./sqrt(x.^2+ytd(dd)^2)) - x;
fx_approximate  = (pi/2)*sin(pi*x./x_max) * (1+xtd(aa)^2+ytd(dd)^2-2*sqrt(xtd(aa)^2+ytd(dd)^2))/(x_max*(cos(pi*xtd(aa)/x_max)+1));

%% Work Integral
exact_work_done = trapz(x,fx_original);
approximate_work_done = trapz(x,fx_approximate);

%% Work Error
work_error(dd,aa) = abs(100*(1-(approximate_work_done/exact_work_done))); 

%% Momentum Integral
%momentum_exact = trapz(x,(fy_original)./((-0.5*((ytd(dd)^2+x.^2).^0.5-1).^2 + 0.5*(sqrt(x(1)^2+ytd(dd)^2)-1).^2)+xdoths));
velocity_exact = (((-1*((ytd(dd)^2+x.^2).^0.5-1).^2 + 1*(sqrt(x(1)^2+ytd(dd)^2)-1).^2)).^0.5+xdoths);
momentum_exact = trapz(x,(fy_original)./velocity_exact);
momentum_approx = trapz(x,fy_approximate/xdoths);

%% Momentum Error
momentum_error(dd,aa) = abs(100*(1-abs(momentum_approx/momentum_exact))); 

%% Remove impossible configurations
 if(xtd(aa)^2+ytd(dd)^2>1)
    work_error(dd,aa) = nan;
    momentum_error(dd,aa) = nan;
 end
end
end


%% Plot
 imAlpha=ones(size(work_error));
 imAlpha(isnan(work_error))=0;
  imagesc(xtd,ytd,work_error,'AlphaData',imAlpha);
  set(gca,'YDir','normal');
  title('Work Error for different touchdowns')
  xlabel('x_{hs}/l_0')
  ylabel('y_{hs}/l_0')
  colorbar;

  figure;
  
  imagesc(xtd,ytd,momentum_error);
   imAlpha=ones(size(momentum_error));
 imAlpha(isnan(momentum_error))=0;
  imagesc(xtd,ytd,momentum_error,'AlphaData',imAlpha);
  set(gca,'YDir','normal');
  title('Momentum Error for different touchdowns')
  xlabel('x_{hs}/l_0')
  ylabel('y_{hs}/l_0')
  colorbar;

