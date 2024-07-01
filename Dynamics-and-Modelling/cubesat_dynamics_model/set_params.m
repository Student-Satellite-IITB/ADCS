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
sat.initialrotationrates=[0, 0, 0];%initial angular velocity of body projected onto the body frame
sat.rw.moi=1;%MOI of reaction wheel with respect to its axis
sat.wheel_axis_unitvector=[0, 1, 0];%Unit vector wrt body frame in direction of wheels axis
