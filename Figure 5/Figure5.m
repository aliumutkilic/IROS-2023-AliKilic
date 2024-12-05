clc;
clear;
close all;

background = 1*[1,1,1];
whitebg(background);
font_size  = 8;
font_name  = 'Myriad';

color = [1,0,0;    % r
         0,0,1;    % g
         0,0.5,0]; % b

marker      = {'o','v','s'};
marker_size = 3;
line_width  = 1;

torque_constant = 0.064;

%% With Magnets

%load with_5hz.mat;
load 5hz_nontrivial_long2.mat
hold on;
figure(1);
subplot(3,1,1)
plot(time,real_pos,'Color',color(1,:),'LineWidth',line_width);
hold on;
xlim([0 50]);
ylim([-70 70]);
xlabel('Time (s)');
ylabel('Position (degrees)');


subplot(3,1,2);
plot(time,current*torque_constant,'Color',color(1,:),'LineWidth',line_width/5);
xlim([0 50]);
xlabel('Time (s)');
ylabel('Torque (Nm)');
hold on;

subplot(3,1,3);
energy1 = cumtrapz(real_pos*pi/180,current*torque_constant);
plot(time,energy1,'Color',color(1,:),'LineWidth',line_width);
hold on;
xlim([0 50]);
xlabel('Time (s)');
ylabel('Energy ');

set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off')
set(gca, 'TickLabelInterpreter','latex');
set(gcf,'Color',background)
box on



%load without_5hz.mat;
load 5hz_nontrivial_without2.mat

subplot(3,1,1);
plot(time,real_pos,'Color',color(2,:),'LineWidth',line_width);
legend('Motor with Magnetic Spring','Motor')

subplot(3,1,2);
plot(time,current*torque_constant,'Color',color(2,:),'LineWidth',line_width/5);
legend('Motor with Magnetic Spring','Motor')

subplot(3,1,3);
energy2 = cumtrapz(real_pos*pi/180,current*0.064);
plot(time,energy2,'Color',color(2,:),'LineWidth',line_width);

legend('Motor with Magnetic Spring','Motor')

%% Switching
figure(2);


load torque_switching_final2.mat;

subplot(3,1,1);
plot(time(1163:end)-time(1163),real_pos(1163:end),'Color',color(1,:),'LineWidth',line_width);
hold on;

subplot(3,1,2);
current = smoothdata(current);
plot(time(1163:end)-time(1163),torque_constant*current(1163:end),'Color',color(1,:),'LineWidth',line_width/5)
hold on;


energy1 = cumtrapz(real_pos*pi/180,current*torque_constant);
subplot(3,1,3);
plot(time(1163:end)-time(1163),energy1(1163:end)-energy1(1163),'Color',color(1,:),'LineWidth',line_width);
hold on;


load sd_card_data2.mat
subplot(3,1,1);

plot(time(1163:end)-time(1163),real_pos(1163:end),'Color',color(2,:),'LineWidth',line_width);
xlim([0 16]);
xlabel('Time (s)');
ylabel('Position (degrees)');

subplot(3,1,2);
plot(time(1163:end)-time(1163),torque_constant*current(1163:end),'Color',color(2,:),'LineWidth',line_width/5)
ylim([-0.19 0.19]);
xlim([0 16]);
xlabel('Time (s)');
ylabel('Torque (Nm)');

energy2 = cumtrapz(real_pos*pi/180,current*torque_constant);
subplot(3,1,3);
plot(time(1163:end)-time(1163),energy2(1163:end)-energy2(1163),'Color',color(2,:),'LineWidth',line_width);
xlim([0 16]);
ylim([0 1.2]);
xlabel('Time (s)');
ylabel('Energy ');

set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off')
set(gca, 'TickLabelInterpreter','latex');
set(gcf,'Color',background)
set(gcf,'renderer','Painters')
box on
