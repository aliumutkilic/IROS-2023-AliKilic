function [val,isterminal,dir] = end_event(t,z)

    global l0;
    val = l0-sqrt(z(1)^2+z(3)^2);
    isterminal = 1;
    dir = -1;

end