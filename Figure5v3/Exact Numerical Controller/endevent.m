function [val,isterminal,dir] = endevent(t,z)
    p = parameters();
    l0=p.l0;
    
    val = l0-sqrt(z(1)^2+z(3)^2);
    isterminal = 1;
    dir = 0;

end