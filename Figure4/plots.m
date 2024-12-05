clc
clear all
close all

background = 1*[1,1,1];
whitebg(background);

color = [1,0,0;   % r
         0,1,0;   % g
         0,0,1;   % b
         0,1,1;   % c
         1,0,1;   % m
         1,1,0;   % y
         0.2,0.2,0.2;  % ?
         0.5,0.5,0.5;   % ?
         0.7,0.7,0.7;];  % ?

load data

figure(1) % angle

%subplot(3,1,1)
plot(t_traj-0.25,rad2deg(x_traj(:,1)),'-k','Linewidth',2)
yline(0);

hold on;
load 5hz_nontrivial_long2.mat
plot(time((20250:22250))-time(20250)-0.25,real_pos(20250:22250))
 xlim([0,1])
ylim([-62 62]);
box on;
axis([0,t_traj(end),1*min(rad2deg(x_traj(:,1))),1*max(rad2deg(x_traj(:,1)))])
 set(gcf,'Color',background)
load data

% hold on
% grid on
% plot(t_traj,ones(size(x_traj(:,1)))*min(x_traj(:,1)),'--k','Linewidth',1)
% hold on
% plot(t_traj,ones(size(x_traj(:,1)))*max(x_traj(:,1)),'--k','Linewidth',1)
% hold on
% ylabel('x_1(t)')
% axis([0,t_traj(end),1.2*min(x_traj(:,1)),1.2*max(x_traj(:,1))])
% set(gcf,'Color',background)
% 
% subplot(3,1,2) % angular velocity
% plot(t_traj,x_traj(:,2),'-k','Linewidth',2)
% grid on
% ylabel('x_2(t)')
% axis([0,t_traj(end),1.2*min(x_traj(:,2)),1.2*max(x_traj(:,2))])
% xlabel('t')
% set(gcf,'Color',background)
% 
% subplot(3,1,3) % motor torque
% stairs(t,tau_motor(:,1),'-k','Linewidth',2)
% hold on
% plot(t(1:end-1),u_min,'--k','Linewidth',1)
% hold on
% plot(t(1:end-1),u_max,'--k','Linewidth',1)
% grid on
% ylabel('u(t)')
% xlabel('t')
% axis([0,t(end),1.1*u_min(1),1.1*u_max(1)])
% set(gcf,'Color',background)

figure(2) % torque
plot(x(:,1),tau_total,'-r','Linewidth',2)
hold on
plot(x(:,1),tau_magnet,'-b','Linewidth',2)
hold on
plot(x(:,1),tau_motor,'-k','Linewidth',2)
hold on
grid on
ylabel('\tau')
xlabel('x')
%axis([0,t(end),1.1*u_min(1),1.1*u_max(1)])
set(gcf,'Color',background)
legend('Total Torque Required = Motor + Magnet','Magnet','Motor')

figure(3) % decomposition
plot(rad2deg(x(:,1)),sum_of_basis_functions,'color','k','linewidth',2,'linestyle','-');
ylabel('\tau');
xlabel('x')
hold on 
for j = 1:p.n
plot(rad2deg(x(:,1)),basis_functions(:,j),'color',color(j,:),'linewidth',1,'linestyle','-');
hold on
end
legend('Sum','Basis','Basis','Basis','Basis','Basis','Basis','Basis','Basis','Basis')
hold on;
load 5hz_nontrivial_without2.mat
current1 = current;
load 5hz_nontrivial_long2.mat
current2 = current;
diff11 = current1(40250:40500)-current2(40250:40500);
figure(2);
hold on
plot(deg2rad(real_pos(40250:40780)),current1(40250:40780)*0.064)
hold on;
plot(deg2rad(real_pos(40250:40750)),(-current2(40250:40750)*0.064))

figure(4)
plot(t_traj(51:253)-t_traj(51),tau_traj(51:253,1),'-k','Linewidth',2)
ylim([-0.2,0.2]);
set(gcf,'Color',background)
%axis([min(x(:,1)),max(x(:,1)),-0.15,0.15])

