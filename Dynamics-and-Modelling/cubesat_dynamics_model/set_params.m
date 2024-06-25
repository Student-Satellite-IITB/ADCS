 %user param setting
sat.sim_time=20;%time the simulation should run in seconds
sat.starttime=[2020, 1, 17, 10, 20, 36];%start time of simulation in UTC
sat.mass=4;%mass of satellite in kg
sat.orb.sma=6971000;%semi major axis of orbit in m
sat.orb.ecc=0.01;%eccentricity of orbit 
sat.orb.inc=50;%inclination of orbit in degrees
sat.orb.raan=95;%RAAN of orbit in degrees
sat.orb.peri=93;%argument of periapse of orbit in degrees
sat.orb.theta=203;%true anomaly of satellite at start time
sat.dragco=2.179;%drag coefficient of satellite
sat.dragarea=1;%effective area for drag of satellite (square meters)
sat.inertiamatrix=[10, -5, 0; -5, 15, 0; 0, 0, 5];%MOI Matrix wrt Body Frame about COM
sat.initialorientation=quaternion([1, 0, 0, 0]);%quaternion of initial orientation of satellite wrt LHLV frame 

%computation
%{
[sat.princaxes, sat.diaginertiamatrix]=eig(sat.inertiamatrix);
i1=sat.diaginertiamatrix(1, 1);
i2=sat.diaginertiamatrix(2, 2);
i3=sat.diaginertiamatrix(3, 3);
disp(i1);
disp(i2);
disp(i3);
disp(sat.princaxes);
sat.quat_princaxeswrtbody=quaternion(rotm2quat(sat.princaxes));
disp(sat.quat_princaxeswrtbody);
sat.omegalvlhx=0;
sat.omegalvlhy=0;
sat.omegalvlhz=0;
sat.omegalvlhquat=quaternion([0, sat.omegalvlhx, sat.omegalvlhy, sat.omegalvlhz]);
temp1=quatinv(sat.initialorientation)*quatinv(sat.quat_princaxeswrtbody);
temp2=temp1*sat.omegalvlhquat;
temp3=temp2*sat.quat_princaxeswrtbody;
sat.omegaprinc=temp3*sat.initialorientation;
sat.omegaprincarray=compact(sat.omegaprinc);
sat.omegaprinc1=sat.omegaprincarray(2);
sat.omegaprinc2=sat.omegaprincarray(3);
sat.omegaprinc3=sat.omegaprincarray(4);
%}