% Teppo Luukkonen, p.3
function y1 = torques(u1)

  global k l b

  w = u1;
  sinpi4 = sin(pi/4.);

  tau1 = l*k*sinpi4*(w(1)^2 - w(2)^2 - w(3)^2 + w(4)^2);
  tau2 = l*k*sinpi4*(-w(1)^2 - w(2)^2 + w(3)^2 + w(4)^2);
  tau3 = b*(-w(1)^2 + w(2)^2 - w(3)^2 + w(4)^2);

  y1 = [tau1,tau2,tau3];
endfunction
