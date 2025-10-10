function [phiD,thetaD] = pdXY(xD,x,yD,y,xdD,xd,ydD,yd)

  errX = xD - x;
  errY = yD - y;

  errU = xdD - xd;
  errV = ydD - yd;

  phiD   = -1e-02*errY - 1e-01*errV;
  thetaD =  1e-02*errX + 1e-01*errU;

%{
  errX = xD - x;
  errY = yD - y;

  ux = 1e-03*errX;
  uy = 1e-03*errY;

  psiD = 0.;

  EulD = [
         [sin(psiD),-cos(psiD)];
         [cos(psiD), sin(psiD)]
         ]*[ux,uy]';

  phiD   = asin(EulD(1));
  phi0 = 0.*pi/180.;
  thetaD = asin(EulD(2)/cos(phi0));
%}

%  phiD  = 10.*pi/180.;
%  thetaD  = 0.;
endfunction
