function CONST=constants

M=75;                      % body mass
H=1.80;                    % body hight 
g=9.81;                    % gravity

m1=(0.1)*M;             % upper leg
m2=(0.0465)*M;             % lower leg
m3=(0.0145)*M;             % foot
m=M-2*(m1+m2+m3);          % had+neck+trunk+hands
                 % upper body lenght
L=0.288*H;
L1=0.245*H;                % upper leg segment
L2=0.246*H;                % lower leg segment

%--------------------
Lc=0.626*L;
%--------------------
Lc1=0.433*L1;
Lc2=0.433*L2;

h=0.039*H;
footh_length=0.152*H;

a=0.75*footh_length;
b=0.25*footh_length;
c=0.25*footh_length;

%--------------------
rg=0.496*L;
%--------------------
rg1=0.323*L1;
rg2=0.302*L2;
rg3=0.475*footh_length;

J=m*(rg^2);
J1=m1*(rg1^2);
J2=m2*(rg2^2);
J3=m3*(rg3^2);

CONST=[m,m1,m2,m3,J,J1,J2,J3,L,Lc,L1,Lc1,L2,Lc2,h,a,b,c,g];
 
end

