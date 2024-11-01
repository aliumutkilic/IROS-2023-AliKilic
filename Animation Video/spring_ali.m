function [spr_x, spr_y,spr_end1x,spr_end2x,spr_end1y,spr_end2y] = spring_ali(x_com,y_com,x_foot,y_foot)
x_f = x_foot;
y_f = y_foot;
x_c = x_com;
y_c = y_com;
d1 = 0.15;
theta = -atan2(y_com-y_foot,x_com-x_foot);
x_foot = x_foot + d1*cos(theta);
y_foot = y_foot + d1*sin(abs(theta));
y_com = y_com - d1*sin(abs(theta));
x_com = x_com + d1*sign(theta)*cos(theta);

l1 = sqrt((x_com-x_foot)^2+(y_com-y_foot)^2);
x = linspace(0,l1,1000);
coil = 10;
f1 = coil/l1;
y = 0.05*1*sin(2*pi*f1*x);
theta = -atan2(y_com-y_foot,x_com-x_foot);
rot_matrix = [cos(theta),sin(theta);-sin(theta),cos(theta)];
state=[x;y];
p = rot_matrix*state+[x_foot;y_foot];
spr_x = p(1,1:end);
spr_y = p(2,1:end);
spr_end1x = [x_f,spr_x(1)];
spr_end2x = [spr_x(end),x_c];
spr_end1y = [y_f,spr_y(1)];
spr_end2y = [spr_y(end),y_c];
end
