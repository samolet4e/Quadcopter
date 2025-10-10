function [phiD,thetaD] = pdXY(xD,x,yD,y,xdD,xd,ydD,yd)

  errX = xD - x;
  errY = yD - y;

  errU = xdD - xd;
  errV = ydD - yd;

  phiD   = -1e-02*errY - 1e-01*errV;
  thetaD =  1e-02*errX + 1e-01*errU;

%  phiD   =-9.5e-04*errY;
%  thetaD = 9.5e-04*errX;

endfunction
