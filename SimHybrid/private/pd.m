function [y] = pd(z,zd,phi,phid,theta,thetad,psi,psid)

  global g m k l b Ixx Iyy Izz

  zdD = 0.;
  zD = 10.;

  phiD = 10.*pi/180.;
  phidD = 0.;

  thetaD = 0.;
  thetadD = 0.;

  psiD = 0.;
  psidD = 0.;

  Kzd = 2.5;
  Kzp = 1.5;

  Kphid = 1.75;
  Kphip = 6.;

  Kthetad = 1.75;
  Kthetap = 6.;

  Kpsid = 1.75;
  Kpsip = 6.;

  T = m/(cos(phi)*cos(theta))*(g + Kzd*(zdD - zd) + Kzp*(zD - z));
  taophi   = (Kphid*(phidD - phid) + Kphip*(phiD - phi))*Ixx;
  taotheta = (Kthetad*(thetadD - thetad) + Kthetap*(thetaD - theta))*Iyy;
  taopsi   = (Kpsid*(psidD - psid) + Kpsip*(psiD - psi))*Izz;

  k4 = k*4.;
  kl2 = k*l*2.;
  b4 = b*4.;

  w1sq = T/k4 - taotheta/kl2 - taopsi/b4;
  w2sq = T/k4 - taophi/kl2   + taopsi/b4;
  w3sq = T/k4 + taotheta/kl2 - taopsi/b4;
  w4sq = T/k4 + taophi/kl2   + taopsi/b4;

  y = [w1sq,w2sq,w3sq,w4sq].^0.5;

%  y = [9,9,9,8.9999]*10^3*pi/30.; % from rpm to 1/sec

endfunction
