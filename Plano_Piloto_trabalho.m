clear
clc
syms thetaX thetaY thetaZ % roll pitch yaw
syms thetaXp thetaYp thetaZp
syms thetaX2p thetaY2p thetaZ2p
syms d1 d2 d3 d4 % disturbios
syms x2p y2p z2p %derivada das posicoes em XYZ
syms Ix Iy Iz Ir% momentos de inercia
syms Uz Uroll Upitch Uyaw
syms m g OmegaR
equ1 = x2p == (cos(thetaX)*sin(thetaY)*cos(thetaZ) + sin(thetaX)*sin(thetaZ))*(Uz/m)+d1;
equ2 = y2p == (cos(thetaX)*sin(thetaY)*sin(thetaZ) - sin(thetaX)*cos(thetaZ))*(Uz/m)+d1;
equ3 = z2p == (cos(thetaX)*cos(thetaY))*(Uz/m) - g + d1;
equ4 = thetaX2p == ((Iy-Iz)/Ix)*thetaYp*thetaXp - (Ir/Ix)*thetaYp*OmegaR + Uroll/Ix + d2;
equ5 = thetaY2p ==((Iz-Ix)/Iy)*thetaZp*thetaXp - (Ir/Iy)*thetaXp*OmegaR + Upitch/Iy + d3;
equ6 = thetaZ2p ==((Ix-Iy)/Iz)*thetaXp*thetaYp + Uyaw/Iz + d4;


Xlin = (cos(thetaX)*sin(thetaY)*cos(thetaZ) + sin(thetaX)*sin(thetaZ))*(Uz/m)+d1;
Ylin = (cos(thetaX)*sin(thetaY)*sin(thetaZ) - sin(thetaX)*cos(thetaZ))*(Uz/m)+d1;
Zlin = (cos(thetaX)*cos(thetaY))*(Uz/m) - g + d1;
Rlin = ((Iy-Iz)/Ix)*thetaYp*thetaXp - (Ir/Ix)*thetaYp*OmegaR + Uroll/Ix + d2;
Plin = ((Iz-Ix)/Iy)*thetaZp*thetaXp - (Ir/Iy)*thetaXp*OmegaR + Upitch/Iy + d3;
Yawlin = ((Ix-Iy)/Iz)*thetaXp*thetaYp + Uyaw/Iz + d4;
%%
linx2p = diff(Xlin,thetaY);
liny2p = diff(Ylin,thetaX);
linz2p = diff(Zlin,Uz);
linR2p = diff(Rlin,Uroll);
linP2p = diff(Plin,Upitch);
linYaw2p = diff(Yawlin,Uyaw);

thetaX = 0;
thetaY = 0;
thetaZ = 0;
Uz = m * g;
syms thetaXlin thetaYlin thetaZlin % roll pitch yaw
syms Uzlin
Xlin = subs(linx2p);
Xlin = Xlin*thetaYlin + d1%correto

Ylin = subs(liny2p);
Ylin = Ylin*thetaXlin + d1%correto

Zlin = subs(linz2p);
Zlin = Zlin*Uzlin - g + d1%correto

Rlin = subs(linR2p);
Rlin = Rlin*Uroll + d2%correto

Plin = subs(linP2p);
Plin = Plin*Upitch + d3%correto

Yawlin = subs(linYaw2p);
Yawlin = Yawlin*Uyaw + d4%correto

%% Montando o espaço de espaços
% %constantes Artigo
% Km = 120; %N
% Kt = 4; % N m
% m = 1.42; %kg
% l =0.2; %m
% Ix = 0.03; %Kg m^2
% Iy = 0.03; %Kg m^2
% Iz = 0.04; %Kg m^2
% g = 9.81;


%constante trabalho
Km = 120; %N
Kt = 4; % N m
m = 0.0630; %kg
l =0.0330; %m
Ix = 0.5829*(10^-4); %Kg m^2
Iy = 0.7169*(10^-4); %Kg m^2
Iz = 1.000*(10^-4); %Kg m^2
g = 9.81;


   A = [0 1 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 g 0 0 0;
        0 0 0 1 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 g 0 0 0 0 0;
        0 0 0 0 0 1 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 1 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 1 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 1;
        0 0 0 0 0 0 0 0 0 0 0 0];
    
   B = [0 0 0 0;
        0 0 0 0;
        0 0 0 0;
        0 0 0 0;
        0 0 0 0;
        (Km/m) (Km/m) (Km/m) (Km/m);
        0 0 0 0;
        ((Km*l)/Ix) (-(Km*l)/Ix) 0 0;
        0 0 0 0;
        0 0 ((Km*l)/Iy) (-(Km*l)/Iy);
        0 0 0 0;
        ((Km*Kt)/Iz) ((Km*Kt)/Iz) (-(Km*Kt)/Iz) (-(Km*Kt)/Iz)];

C = [1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 1 0 0 0 0 0;
    0 0 0 0 0 0 0 0 1 0 0 0;
    0 0 0 0 0 0 0 0 0 0 1 0];
 D = [0 0 0 0;
     0 0 0 0;
     0 0 0 0;
     0 0 0 0;
     0 0 0 0;
     0 0 0 0];
 
 sys = ss(A,B,C,D)
%% Discretização
T = 0.01; % tempo de amostragem
% G = expm(A*T);
% syms t
% H = vpa(int(expm(A*t)*B,t,0,T),4);
%c2d(sys,T) tbm funciona
Ck = C;
Dk = D;
%metodo de Euler
G = eye(12) + A*T;
H = T*B;

sysD = ss(G,H,Ck,Dk)
%% tentativa dLQR expandido
Gnew = [eye(6) Ck*G;
        zeros(12,6) G]   
Gnew(isinf(Gnew)|isnan(Gnew)) = 0;

Hnew = [Ck*H;H];
Hnew(isinf(Hnew)|isnan(Hnew)) = 0;
Cnew = [zeros(6) Ck]




%%sysD = ss(Gnew,Hnew,Cnew,T)
%%
%Valores Preliminares de Q e R
% NÃO SAO VALORES FINAIS PELA AMOR DE DEUS
% POR FAVOR BAWDEN MUDE ELES

Q = eye(18);
R = eye(4);

[K,S,E]= dlqr(Gnew,Hnew,Q,R);

