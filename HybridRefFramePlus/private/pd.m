function [y] = pd(t,X,U,angRate,quat);

  global J m g
  global k l b

  Eul = quat2Euler(quat);

  phi   = Eul(1);
  theta = Eul(2);
  psi   = Eul(3);

  p = angRate(1);
  q = angRate(2);
  r = angRate(3);

  M = [
      [1., sin(phi)*tan(theta), cos(phi)*tan(theta)];
      [0., cos(phi), -sin(phi)];
      [0., sin(phi)/cos(theta), cos(phi)/cos(theta)]
      ]*[p,q,r]';

  phid   = M(1);
  thetad = M(2);
  psid   = M(3);

  x = X(1);
  y = X(2);
  z = X(3);

  xd = U(1);
  yd = U(2);
  zd = U(3);

%{
  zdD = 0.;
  zD = 10.;

  xdD = 0.;
  xD = 0.;

  ydD = 0.;
  yD = -80.;
%}

  zdD = 0.;
  zD  = 10.;

  xdD = 0.;
  xD  = 0.;

  ydD = 0.;
  yD  = 0.;

  if (t <= 15)
    xD = 0.;
    yD = -60.;
  elseif (t > 15 && t <= 30)
    xD = -50.;
    yD = -50.;
  elseif (t > 30 && t <= 45)
    xD = -40.;
    yD = 0.;
  elseif (t > 45 && t <= 60)
    xD = 10.;
    yD = -10.;
  else
  endif

  [phiD,thetaD] = pdXY(xD,x,yD,y,xdD,xd,ydD,yd);

%  phiD  = 10.*pi/180.;
  phidD = 0.;

%  thetaD  = 0.;
  thetadD = 0.;

  psiD  = 0.;
  psidD = 0.;

  Kzd = 2.5;
  Kzp = 1.5;

  Kphid = 1.75;
  Kphip = 6.;

  Kthetad = 1.75;
  Kthetap = 6.;

  Kpsid = 1.75;
  Kpsip = 6.;

  Jxx = J(1,1); Jyy = J(2,2); Jzz = J(3,3);
  T = m/(cos(phi)*cos(theta))*(g + Kzd*(zdD - zd) + Kzp*(zD - z));
  taophi   = (Kphid*(phidD - phid) + Kphip*(phiD - phi))*Jxx;
  taotheta = (Kthetad*(thetadD - thetad) + Kthetap*(thetaD - theta))*Jyy;
  taopsi   = (Kpsid*(psidD - psid) + Kpsip*(psiD - psi))*Jzz;

  k4 = k*4.;
  kl2 = k*l*2.;
  b4 = b*4.;

  w1sq = T/k4 - taotheta/kl2 - taopsi/b4;
  w2sq = T/k4 - taophi/kl2   + taopsi/b4;
  w3sq = T/k4 + taotheta/kl2 - taopsi/b4;
  w4sq = T/k4 + taophi/kl2   + taopsi/b4;

  y = [w1sq,w2sq,w3sq,w4sq].^0.5;
endfunction

