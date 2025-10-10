clear;

global J m g
global k l b

J = [
    [4.856e-03, 0., 0.];
    [0,  4.856e-03, 0.];
    [0., 0., 4.856e-03]
    ];

g = 9.81;
m = 0.468;

l = 0.225; % Linear distance from the centre of the rotor to the centre of gravity
k = 2.980e-6; % Thrust factor of rotor (depends on density geometry, etc.)
b = 1.140e-7; % Drag constant

tspan = linspace(0,60,200);
x0   = [0.,0.,0.]; % x0,y0,z0
u0   = [0.,0.,0.]; % u0,v0,w0
p0   = [0.,0.,0.]; % p0,q0,r0
Eul0 = [0.,0.,0.]; % phi0, theta0, psi0
quat0 = eul2Quat(Eul0,'ZYX');
xinit = [x0,u0,p0,quat0];
[t,x] = ode45(@f,tspan,xinit);

quat = [x(:,10),x(:,11),x(:,12),x(:,13)];
Euler = zeros(size(tspan)(2),3);
for i = 1:size(tspan)(2)
  Euler(i,:) = quat2Euler(quat(i,:)); % phi,theta,psi
endfor

figure(1);
plot(tspan,Euler(:,1)*180/pi,'LineWidth',2);
xlabel('time,s'); ylabel('phi,deg');
grid on
set(gca,'FontSize',12);

figure(2);
plot(tspan,Euler(:,2)*180/pi,'LineWidth',2);
xlabel('time,s'); ylabel('theta,deg');
grid on
set(gca,'FontSize',12);

figure(3);
%scatter3(x(:,1),x(:,2),x(:,3));
plot3(x(:,1),x(:,2),x(:,3),'-','LineWidth',2);
xlabel('X,m'); ylabel('Y,m'); zlabel('Z,m');
axis equal
grid on
set(gca,'FontSize',12);

dlmwrite('../Show/output.csv',[x(:,1),x(:,2),x(:,3),Euler(:,1),Euler(:,2),Euler(:,3)],',');

