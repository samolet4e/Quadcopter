function y1 = quat2Euler(u1)

%    q = zeros(4,1);
    q(1) = u1(1);
    q(2) = u1(2);
    q(3) = u1(3);
    q(4) = u1(4);
    q = q/norm(q);
    q0 = q(1); q1 = q(2); q2 = q(3); q3 = q(4);

    % Zipfel, p.127
    num = 2.*(q2*q3 + q0*q1);
    denom = q0^2 - q1^2 - q2^2 + q3^2;
    phi = atan2(num,denom);

    num = -2.*(q1*q3 - q0*q2);
    theta = asin(num);

    num = 2.*(q1*q2 + q0*q3);
    denom = q0^2 + q1^2 - q2^2 - q3^2;
    psi = atan2(num,denom);

    y1 = [phi, theta, psi];
endfunction

