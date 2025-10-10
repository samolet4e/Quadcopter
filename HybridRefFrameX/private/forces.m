% Teppo Luukkonen, p.3
function y1 = forces(u1)

  global k

  w = u1;
  T = k*(w(1)^2 + w(2)^2 + w(3)^2 + w(4)^2);

  y1 = [0,0,T];
endfunction
