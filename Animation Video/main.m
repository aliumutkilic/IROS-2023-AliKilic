function  plots()

clc
close all
clear all

t = dlmread('timed.txt');
q = [dlmread('xxpos.txt'),dlmread('yypos.txt'),dlmread('leg1x.txt'),dlmread('leg2x.txt'),3*dlmread('leg1y.txt'),3*dlmread('leg2y.txt')];
v = [dlmread('xxdot.txt'),dlmread('yydot.txt')]; % only for testing
gg = [dlmread('kvector.txt')];
dd = [dlmread('endpos.txt')];
ee = [dlmread('endvertx.txt')];
ll = [dlmread('endverty.txt')];
mm = [dlmread('steps.txt')];
%load t t
%load q q
%load v v

%animation(t,q,v);
animation1(t,q,v,gg,dd,ee,ll,mm);

%figure(2)
% plot(t,v(:,1),'Color','black','LineWidth',1)
% hold on;
% %title('Upper body')
% xlabel('Time (s)'); 
% ylabel('Speed (m/s)');
% grid off
% hold on
% axis([0,10,0,1.75]);

end