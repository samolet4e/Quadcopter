function xdot = f(t,x)

  global m Ixx Iyy Izz
  global b l k g Ir
  global validate

  xI = x(1);
  yI = x(2);
  zI = x(3);

  uI = x(4);
  vI = x(5);
  wI = x(6);

  p = x(7);
  q = x(8);
  r = x(9);

  phi   = x(10);
  theta = x(11);
  psi   = x(12);

  % From body to inertial
  W = [
      [1,sin(phi)*tan(theta),cos(phi)*tan(theta)],
      [0,cos(phi),-sin(phi)],
      [0,sin(phi)/cos(theta),cos(phi)/cos(theta)]
      ];

  _t = W*[p,q,r]';

  phid   = _t(1);
  thetad = _t(2);
  psid   = _t(3);

  wr = pd(zI,wI,phi,phid,theta,thetad,psi,psid); % motor revs, 1/sec
  if (validate)
     wr = [0,0,0,0];
  endif

%printf('%f\t%f\t%f\t%f\t%f\n',t,wr(1)*60/(2*pi),wr(2)*60/(2*pi),wr(3)*60/(2*pi),wr(4)*60/(2*pi));

  invM = inv([[eye(3)*m,zeros(3,3)];[zeros(3,3),diag([Ixx,Iyy,Izz])]]);
  R = Rfunc(phi,theta,psi);

  if (validate)
  % Validation: include air resistance
    Vb = R'*[uI,vI,wI]'; % linear velocity in body frame
    Db = -1*m*Vb; % air drag in body frame
    D = [R*Db;[0,0,0]']; % air drag in inertial frame
  endif

  uB = [
       [0,0,0,0];
       [0,0,0,0];
       [k,k,k,k];
       [0,-l*k,0,l*k];
       [-l*k,0,l*k,0];
       [-b,b,-b,b]
       ]*[wr(1)^2,wr(2)^2,wr(3)^2,wr(4)^2]';

  C = [zeros(3,3),zeros(3,3);zeros(3,3),[[0,-r*Iyy,q*Izz];[r*Ixx,0,-p*Izz];[-q*Ixx,p*Iyy,0]]];
  gB = [[0,0,-m*g]';[0,0,0]'];
  _t = R*[0,0,uB(3)]';
  uB(1:3) = _t(:);

  if (validate)
    % Validation
    uB = uB + D;
  endif

  xdot(1) = x(4);
  xdot(2) = x(5);
  xdot(3) = x(6);

  r36 = -Ir*cross([p,q,r],[0,0,1])*((-1)^1*wr(1) +
                                    (-1)^2*wr(2) +
                                    (-1)^3*wr(3) +
                                    (-1)^4*wr(4)
                                   );

  oB = [[0,0,0]';r36'];

  _t = invM*(gB + uB + oB - C*[uI,vI,wI,p,q,r]');

  xdot(4) = _t(1);
  xdot(5) = _t(2);
  xdot(6) = _t(3);

  xdot(7) = _t(4);
  xdot(8) = _t(5);
  xdot(9) = _t(6);

  xdot(10) = phid;
  xdot(11) = thetad;
  xdot(12) = psid;

endfunction
