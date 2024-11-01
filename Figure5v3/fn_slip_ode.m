function zdot = fn_slip_ode(t,z,k,p)

    %p = parameters();
    m  = p.m;
    l0 = p.l0;
    g  = p.g;
    %k = param1;

    zdot    = zeros(4,1);
    zdot(1) = z(2);                                                         %Horizontal Velocity (m/s)
    zdot(2) = ((k*l0*z(1)/sqrt((z(1)^2+z(3)^2)))-k*z(1))/m;                 %Horizontal Acceleration (m/s^2)
    zdot(3) = z(4);                                                         %Vertical Velocity (m/s)
    zdot(4) = ((k*l0*z(3)/sqrt((z(1)^2+z(3)^2)))-k*z(3))/m-g;               %Vertical Acceleration (m/s^2)

end