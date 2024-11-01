clc;
clear;
close all;

load approx.mat;

fileID = fopen('leg2y.txt','w');
fprintf(fileID,'%.6f\n',foot_2_y);
fclose(fileID);


fileID = fopen('leg2x.txt','w');
fprintf(fileID,'%.6f\n',foot_2_x);
fclose(fileID);


fileID = fopen('leg1x.txt','w');
fprintf(fileID,'%.6f\n',foot_1_x);
fclose(fileID);

fileID = fopen('leg1y.txt','w');
fprintf(fileID,'%.6f\n',foot_1_y);
fclose(fileID);


fileID = fopen('xxpos.txt','w');
fprintf(fileID,'%.6f\n',x_vector);
fclose(fileID);

fileID = fopen('yypos.txt','w');
fprintf(fileID,'%.6f\n',y_vector);
fclose(fileID);

fileID = fopen('xxdot.txt','w');
fprintf(fileID,'%.6f\n',xdot_vector);
fclose(fileID);

fileID = fopen('yydot.txt','w');
fprintf(fileID,'%.6f\n',ydot_vector);
fclose(fileID);

fileID = fopen('timed.txt','w');
fprintf(fileID,'%.6f\n',time_data);
fclose(fileID);