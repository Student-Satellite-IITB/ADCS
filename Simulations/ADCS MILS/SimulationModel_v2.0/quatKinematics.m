function quatdot = quatKinematics(u)
    quat = u(1:4);
    p = u(5);
    q = u(6);
    r = u(7);
    quatdot = 0.5*[0,-p,-q,-r;
                p,0,r,-q;
                q,-r,0,p;
                r,q,-p,0]*quat;
end