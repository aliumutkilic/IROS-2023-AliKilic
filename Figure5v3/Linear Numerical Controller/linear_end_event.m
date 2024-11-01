function [val,isterminal,dir] = linear_end_event(t,z)



isterminal = 1;
val = z(1)-1;
    dir = 0;
end