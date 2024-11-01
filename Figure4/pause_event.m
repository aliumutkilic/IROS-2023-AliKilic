function [val,isterminal,dir] = pause_event(t,z)

    global l0;

    a = sqrt(z(1)^2+z(3)^2);

    if a>=l0
    val = 0;
    isterminal =1;
    dir = 0;
    else
    val = z(1);
    isterminal = 1;
    dir = 0;
    end
end