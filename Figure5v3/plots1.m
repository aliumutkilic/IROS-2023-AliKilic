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


%% Linear SLIP

% load data_linear_SLIP

%...

%% Exact SLIP

load data_exact_SLIP

% figure(1)
% plot(x_vector,y_vector,'-','Color',color(2,:),'LineWidth',line_width);
% hold on

hold on;
figure(2);
subplot(2,2,1)
hold on
plot([0:1:i],xdot_end_dimensionless,'.','Color',color(2,:),'Marker',marker{2},'MarkerFaceColor',color(2,:),'MarkerEdgeColor',color(2,:),'MarkerSize',marker_size);

subplot(2,2,2);
hold on;
plot([0:1:i],ydot_end_dimensionless,'.','Color',color(2,:),'Marker',marker{2},'MarkerFaceColor',color(2,:),'MarkerEdgeColor',color(2,:),'MarkerSize',marker_size);

subplot(2,2,3);
hold on;
plot([1:1:i],stepping_policy,'.','Color',color(2,:),'Marker',marker{2},'MarkerFaceColor',color(2,:),'MarkerEdgeColor',color(2,:),'MarkerSize',marker_size)

subplot(2,2,4);
hold on;
plot([1:1:i],stiffness_ratio,'.','Color',color(2,:),'Marker',marker{2},'MarkerFaceColor',color(2,:),'MarkerEdgeColor',color(2,:),'MarkerSize',marker_size)

%% Linear SLIP

load data_linear_SLIP

figure(2);
subplot(2,2,1)
hold on
plot([0:1:i],xdot_end_dimensionless,'.','Color',color(3,:),'Marker',marker{3},'MarkerFaceColor',color(3,:),'MarkerEdgeColor',color(3,:),'MarkerSize',marker_size);

subplot(2,2,2);
hold on;
plot([0:1:i],ydot_end_dimensionless,'.','Color',color(3,:),'Marker',marker{3},'MarkerFaceColor',color(3,:),'MarkerEdgeColor',color(3,:),'MarkerSize',marker_size);

subplot(2,2,3);
hold on;
plot([1:1:i],stepping_policy,'.','Color',color(3,:),'Marker',marker{3},'MarkerFaceColor',color(3,:),'MarkerEdgeColor',color(3,:),'MarkerSize',marker_size)

subplot(2,2,4);
hold on;
plot([1:1:i],stiffness_ratio,'.','Color',color(3,:),'Marker',marker{3},'MarkerFaceColor',color(3,:),'MarkerEdgeColor',color(3,:),'MarkerSize',marker_size)

%% Approximate SLIP

load data_approximate_SLIP

figure(1)
plot(x_vector,y_vector,'-','Color',color(1,:),'LineWidth',line_width);
axis([-0.1,9,-0.1,1.3])
ylabel('Height y (m)','interpreter','latex')
xlabel('Distance x (m)','interpreter','latex')
title('Center of mass trajectory','interpreter','latex'); % not needed 
set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off','XTick',[0:1:30],'YTick',[0:0.5:1])
set(gca, 'DataAspectRatio', [1,1,1]);
set(gca, 'TickLabelInterpreter','latex');
set(gca, 'TickLength',[0.005,0.005]);
set(gcf,'Color',background)
box on

figure(2)
subplot(2,2,1)
plot([0,30],[1.2,1.2],'--','Color',color(1,:))
hold on
plot([1:1:i+1],xdot_end_dimensionless,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
hold on
plot(0,xdot_0_dimensionless,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
axis([0,30,0.6,1.4])
xlabel('Number of steps (-)','interpreter','latex'); % not needed 
ylabel('$\dot{x} / \sqrt{g l_{0}}$ (-)','interpreter','latex')
title('Horizontal velocity','interpreter','latex'); % not needed 
set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off','XTick',[0:5:30],'YTick',[0:0.2:1.4])
set(gca, 'TickLabelInterpreter','latex');
set(gcf,'Color',background)
box on
% you can use this when all the plots are presented...
%legend('Proposed SLIP controller','Exact SLIP controller','Linearized SLIP controller','Location','northwest')
legend('Exact SLIP controller','Linearized SLIP controller','','Proposed SLIP controller','Location','northwest','Interpreter','latex')
legend boxoff

subplot(2,2,2)
plot([0,30],[0,0],'--','Color',color(1,:))
hold on
plot([1:1:i+1],ydot_end_dimensionless,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
hold on
plot(0,ydot_0_dimensionless ,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
axis([0,30,-0.4,0.4])
xlabel('Number of steps (-)','interpreter','latex'); % not needed 
ylabel('$\dot{y} / \sqrt{g l_{0}}$ (-)','interpreter','latex')
title('Vertical velocity','interpreter','latex'); % not needed 
set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off','XTick',[0:5:30],'YTick',[-0.4:0.2:0.4])
set(gca, 'TickLabelInterpreter','latex');
box on

subplot(2,2,3)
plot([0,30],[-1,-1],'--','Color',color(1,:))
hold on
plot([1:1:i],stepping_policy,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
hold on
axis([0,30,-1.2,0])
xlabel('Number of steps (-)','interpreter','latex');
ylabel('$x_{hs}/x_{td}$ (-)','interpreter','latex');
title('Step symmetry','interpreter','latex'); % not needed 
set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off','XTick',[0:5:30],'YTick',[-1.2,-1,-0.75,-0.5,-0.25,0])
set(gca, 'TickLabelInterpreter','latex');
set(gcf,'Color',background)
box on

subplot(2,2,4)
plot([0,30],[1,1],'--','Color',color(1,:))
hold on
plot([1:1:i],stiffness_ratio,'.','Color',color(1,:),'Marker',marker{1},'MarkerFaceColor',color(1,:),'MarkerEdgeColor',color(1,:),'MarkerSize',marker_size)
hold on
axis([0,30,0,2])
xlabel('Number of steps (-)','interpreter','latex');
ylabel('$k_2/k_1$ (-)','interpreter','latex')
title('Stiffness ratio','interpreter','latex'); % not needed 
set(gca,'FontName',font_name,'FontSize',font_size,'XminorTick','off','YMinorTick','off','XTick',[0:5:30],'YTick',[0:0.5:2])
set(gca, 'TickLabelInterpreter','latex');
box on
