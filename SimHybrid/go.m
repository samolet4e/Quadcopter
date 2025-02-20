clear;

global m Ixx Iyy Izz
global b l k g Ir
global g m k l b Ixx Iyy Izz
global validate

validate = 0; % 0 - no; 1 - yes

m = 0.468; % kg
Ixx = 4.856e-3; % kg*m^2
Iyy = 4.856e-3; % kg*m^2
Izz = 8.801e-3; % kg*m^2

Ir  = 3.357e-5; % Inertia moment of the rotor, kg*m^2

l = 0.225; % Linear distance from the centre of the rotor to the centre of gravity
b = 1.140e-7; % Drag constant
k = 2.980e-6; % Thrust factor of rotor (depends on density geometry, etc.)

g = 9.81; % m/s^2

tspan = linspace(0,10,100);

if (validate)
   V = 100.; alpha = 45.*pi/180.;
   u0 = V*cos(alpha); w0 = V*sin(alpha);
   [t,x] = ode45(@f,tspan,[0,0,0,u0,0,w0,0,0,0,0,0,0]);
else
               %@rhs, tspan, ic: x,y,z,u,v,w,p,q,r,phi,theta,psi
  [t,x] = ode45(@f,tspan,[0,0,0,0,0,0,0,0,0,0,0,pi]);
endif

figure(1);
plot3(x(:,1),x(:,2),x(:,3),'LineWidth',2);
title('Hybrid System');
xlabel('X,m'); ylabel('Y,m'); zlabel('Z,m');
axis equal
set(gca,'FontSize',14);
grid on
%{
xlim ([0,80]);
xbounds = xlim();
set(gca,'xtick',xbounds(1):20:xbounds(2));

zlim ([-20,50]);
zbounds = zlim();
set(gca,'ztick',zbounds(1):10:zbounds(2));
%}

figure(2);
plot(t,x(:,12)*180/pi,'LineWidth',2);
set(gca,'FontSize',14);
%ylim([-5 15]);
xlabel('t,s'); ylabel('psi,deg');
grid on

dlmwrite('../Show/output.csv',[x(:,1),x(:,2),x(:,3),x(:,10),x(:,11),x(:,12)],',');

