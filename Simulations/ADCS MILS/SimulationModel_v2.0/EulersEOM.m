function wdot = EulersEOM(u)
    w = u(1:3);
    m = u(4:6);
    J = evalin('base', 'sat.J');
    wdot = J\(-cross(w,(J*w))+m);
end