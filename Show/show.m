clear;

x = csvread('output.csv');
[v, f, n, c, stltitle] = stlread('droneLow_feet.stl');

p = patch('faces', f, 'vertices', v, ...
  'facecolor', [0.8 0.8 1.0], ...
  'EdgeColor', 'none', ...
  'FaceLighting', 'gouraud', ...
  'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
grid on

hold on
plot3(x(:,1),x(:,2),x(:,3),'LineWidth',2);

sizeX = size(x(:,1));
sizeV = size(v(:,1));

x_ = x(:,1);
y  = x(:,2);
z  = x(:,3);

phi   = x(:,4);
theta = x(:,5);
psi   = x(:,6);

for i = 1:5:sizeX(1)

    quat = eul2Quat([psi(i),theta(i),phi(i)],'ZYX');
    [CBLL] = dcm(quat);
    T = CBLL;

    v1 = T*v';

    x1 = repmat([x_(i),y(i),z(i)],sizeV(1),1);
    v2 = v1' + x1;

    clf;
    p = patch('faces', f, 'vertices', v2);
    set(p, 'facecolor', [0.8 0.8 1.0]);
    set(p, 'EdgeColor', 'none');
    set(p, 'FaceLighting', 'gouraud');
    set(p, 'AmbientStrength', 0.15);
    grid on;
    axis('image');
    view([-135 35]);
    camlight('headlight');
    material('dull');
    hold on;
    plot3(x_,y,z,'LineWidth',2);
    xlabel('X,m'); ylabel('Y,m'); zlabel('Z,m');
    pause(0.1);

end
set(gca,'FontSize',14);
