function xdot = f(t,x)

  global J m g

  xI = x(1);
  yI = x(2);
  zI = x(3);

  uI = x(4);
  vI = x(5);
  wI = x(6);

  p = x(7);
  q = x(8);
  r = x(9);

  q0 = x(10);
  q1 = x(11);
  q2 = x(12);
  q3 = x(13);

  G = [0,0,-m*g];

  wr = pd(t,[xI,yI,zI],[uI,vI,wI],[p,q,r],[q0,q1,q2,q3]);
%  printf('%f\t%f\t%f\t%f\t%f\n',t,wr*30./pi); % sec^-1 to RPM

  F = forces(wr);
  DCM = dcm([q0,q1,q2,q3]);
  F = (DCM*F')';
  T = torques(wr);

  Ir  = 3.357e-5; % Inertia moment of the rotor, kg*m^2
  o = -cross([p,q,r],[0,0,1])*Ir*(-wr(1) + wr(2) - wr(3) + wr(4));

  f = F + G;
  tau = T + o;

  I = [m*eye(3),zeros(3);zeros(3),J];
  invI = inv(I);

  Jxx = J(1,1); Jyy = J(2,2); Jzz = J(3,3);
  C22 = -1.*[
        [0., -Jzz*r, Jyy*q];
        [Jzz*r, 0., -Jxx*p];
        [-Jyy*q, Jxx*p, 0.]
        ];
  C = [zeros(3),zeros(3);zeros(3),C22];

  xdot2 = invI*([f,tau]' - C*[uI,vI,wI,p,q,r]');

  xdot1 = [uI,vI,wI]';

  M = [
      [0, -p, -q, -r];
      [p, 0, r, -q];
      [q, -r, 0, p];
      [r, q, -p, 0]
      ];

  Qdot = 0.5*M*[q0,q1,q2,q3]';

%printf('%f\t%f\t%f\t%f\n',t,x(1),x(2),x(3)); % x and y are swapped

  xdot = [xdot1;xdot2;Qdot]';
endfunction

