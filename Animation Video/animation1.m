function [] = animation1(t,q,v,gg,dd,ee,ll,mm)

dt = t(2) - t(1);

PP=0; % PP=1 joint moments; PP=2 link moments
WW=0;

qq=q;

C=constants;
m=C(1);
m1=C(2);
m2=C(3);
m3=C(4);
J=C(5);
J1=C(6);
J2=C(7);
J3=C(8);
L=C(9);
Lc=C(10);
L1=C(11);
Lc1=C(12);
L2=C(13);
Lc2=C(14);
h=C(15);
a=C(16);
b=C(17);
c=C(18);
g=C(19);

Q=q;

%nt=1
nt=length(t)
ntstep=round((nt-1)/(500))
ntstep=round((nt-1)/(1000))
nq=size(q);
j=0;

figure('Renderer', 'opengl', 'Position', [100, 100, 1600, 800])
%set(gcf, 'Position',  [100, 100, 1600, 800])
set(gcf,'color','w');

vid = VideoWriter('Walk.avi');
vid.FrameRate = 40;
vid.Quality = 100;
open(vid);

FS = 12;
LW = 3;

color1 = [0,0,0];
color2 = [1,0,0];
color3 = [0.7 0.7 0.7];

Nt = nt/1.4; % set the time range

for i=1:ntstep:Nt

j=j+1;

q=Q(i,1:nq(2));

P1 = [q(1),q(2)]; % COM
P2 = [q(3),0.1*q(5)];    % Foot
P3 = [q(4),0.1*q(6)];    % Foot
P2y = [q(5),0];
P3y = [q(6),0];
%compression = q(7);
% if t(i) > 5.1 && t(i) < 7.3
%    color = color2;
% else
   color = color1;
% end


[spr_x, spr_y,spr_end1x,spr_end2x,spr_end1y,spr_end2y] = spring_ali(q(1), q(2), q(4), 0.1*q(6));
[spr_x2, spr_y2,spr_end1x2,spr_end2x2,spr_end1y2,spr_end2y2] = spring_ali(q(1), q(2), q(3), 0.1*q(5));


subplot(3,2,[1 2]);
cla
plot(qq(:,1),qq(:,2),'Color',color3,'LineWidth',1);hold on
plot(P1(1),P1(2),'o','Color',color,'LineWidth',LW,'MarkerFaceColor',color,'MarkerEdgeColor',color);hold on
plot(spr_end1x,spr_end1y,'-','Color',color ,'LineWidth',LW);hold on
plot(spr_end2x,spr_end2y,'-','Color',color ,'LineWidth',LW);hold on
%plot(linspace(P1(1),P3(1)), linspace(P1(2),P3(2)),'-','Color',color3 ,'LineWidth',LW);hold on
plot(spr_x,spr_y,'Color',color);
hold on;
plot(spr_x2,spr_y2,'Color',color3);
hold on
plot(spr_end1x2,spr_end1y2,'-','Color',color ,'LineWidth',LW);hold on
plot(spr_end2x2,spr_end2y2,'-','Color',color3,'LineWidth',LW);hold on
%plot(spr_x2,spr_y2);
hold on;
%plot(linspace(-1,10), linspace(0,0), '-','Color','black','LineWidth',1);
set(gca, 'DataAspectRatio', [1,1,1]);
axis([-0.99,20,0,1.8]);
xlabel('Distance (m)');
ylabel(' ');
title('Spring Loaded Inverted Pendulum Model of Legged Locomotion');

% if t(i) > 5.1 && t(i) < 5.3
%     text(2.5, 1.02, 'Perturbation', 'FontSize', FS )
%     quiver(3.5, 1, 0.6, 0, 0, 'color', [1 0 0], 'LineWidth', 2);
% end

set(gca,'ytick',[]);
set(gca,'ycolor',[1 1 1])
set(gca,'TickLength',[0 0])
set(gca,'FontSize',FS)

%InSet = get(gca, 'TightInset');
%set(gca, 'Position', [InSet(1:2)+0.01, 1-InSet(1)-InSet(3) - 0.02, 1-InSet(2)-InSet(4)-0.02]);
box off

%check for perturbation
subplot(3,2,3);


cla
%v(:,1)
plot(qq(:,1),v(:,1)/sqrt(9.81),'Color',color1,'LineWidth',1)   



size(5.101:0.001:7.3)
%size(v(5100:7300,1))

hold on;
plot([qq(i,1) qq(i,1)], [0 5], 'Color', color3, 'LineWidth', 3)
hold on;
yline(1.2,'Color',[0.8500 0.3250 0.0980]);
hold on;
scatter(dd,ee/sqrt(9.81),15,'MarkerEdgeColor',[0 0.4470 0.7410]);
hold on;
axis([-0.99,20, 0, 5]);
ylabel('Horizontal Speed (m/s)');
xlabel('Horizontal Position (m)');
xlim([-0.99 20]);
ylim([0.6 1.4]);
pbaspect([5 1 1])


subplot(3,2,4);


cla
%v(:,2)
plot(qq(:,1),v(:,2)/sqrt(9.81),'Color',color1,'LineWidth',1)   

hold on;
scatter(dd,ll/sqrt(9.81),15,'MarkerEdgeColor',[0 0.4470 0.7410]);

size(5.101:0.001:7.3)
%size(v(5100:7300,1))

hold on;
plot([qq(i,1) qq(i,1)], [0.4 -0.4], 'Color', color3, 'LineWidth', 3)
hold on;
yline(0,'Color',[0.8500 0.3250 0.0980]);
hold on;
axis([-0.99,20, 0, 5]);
ylabel('Vertical Speed (m/s)');
xlabel('Horizontal Position (m)');
xlim([-0.99 20]);
ylim([-0.4 0.4]);
pbaspect([5 1 1])


subplot(3,2,5);
cla
%gg(1:end)

plot(qq(:,1),mm,'Color',color1,'LineWidth',1)   
hold on;
% if t(i) > 5.1
%    plot(5.101:0.001:7.3,v(5101:7300,1),'Color',color2,'LineWidth',1)
%    hold on
%    plot(t(7301:end),v(7301:end,1),'Color',color1,'LineWidth',1)   
% else
% end

size(5.101:0.001:7.3)
%size(v(5100:7300,1))

hold on;
plot([qq(i,1) qq(i,1)], [0 -1.2], 'Color', color3, 'LineWidth', 3);
hold on;
yline(-1,'Color',[0.8500 0.3250 0.0980]);
hold on;
axis([-0.99,20, -1.2, 0]);
ylabel('x_{hs}/x_{to}');
xlabel('Horizontal Position (m)');
yticks([-1.2,-1,-0.8,-0.4,0]);
pbaspect([5 1 1])

subplot(3,2,6);
cla
%gg(1:end)

plot(qq(:,1),gg/(10^4),'Color',color1,'LineWidth',1)   

% if t(i) > 5.1
%    plot(5.101:0.001:7.3,v(5101:7300,1),'Color',color2,'LineWidth',1)
%    hold on
%    plot(t(7301:end),v(7301:end,1),'Color',color1,'LineWidth',1)   
% else
% end

size(5.101:0.001:7.3)
%size(v(5100:7300,1))

hold on;
plot([qq(i,1) qq(i,1)], [0 5], 'Color', color3, 'LineWidth', 3)
axis([-0.99,20, 0, 7]);
ylabel('Stiffness (N/m)x10^4');
xlabel('Horizontal Position (m)');
yticks([0 2 6 8]);
pbaspect([5 1 1])

% if t(i) > 5.1
%     plot([5.1 5.1], [0 1.5],'--', 'Color', 'r');
%     text(3.6, 0.4, 'F = 200N, \Delta t = 0.2s', 'FontSize', FS , 'Color', 'r')
% end
% 
% if t(i) > 5.3
%     plot([5.3 5.3], [0 1.5],'--', 'Color', 'r');
% end
% 
% if t(i) > 7.3
%     plot([7.3 7.3], [0 1.5], '--', 'Color', 'r');
%     %text(7.4, 0.4, 'Robot recovers', 'Color', [0 0 0], 'FontSize', FS );
% end
 ha=get(gcf,'children');
 set(ha(1),'position',[.55 .05 .4 .5])
 set(ha(2),'position',[.1 .05 .4 .5])
 set(ha(3),'position',[.55 .3 .4 .5])
 set(ha(4),'position',[.1 .3 .4 .5])

if t(i) > 5.1 && t(i) < 5.13
    frame = getframe(gcf);
    for ind = 1:50
        writeVideo(vid,frame);
    end
else
    frame = getframe(gcf);
    writeVideo(vid,frame);
end
%box off
%set(gca,'ytick',[]);
%set(gca,'ycolor',[1 1 1])
set(gca,'TickLength',[0 0])
set(gca,'ytick',0:1:5);

%set(gca,'FontSize',FS)
end
close(vid);
%movie(Mov,1,25)
%movie2avi(Mov,'biped_walk','quality',100,'fps',10);
end