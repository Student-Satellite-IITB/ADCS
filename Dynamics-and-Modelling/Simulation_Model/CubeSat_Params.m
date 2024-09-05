%% CUBESAT Parameters

% Author: Ameya Marakarkandy
% Last Updated: 15/08/2024
%
% @brief 
% Initialises parameters needed for
% CubeSat Simulation Model

%% Physical parameters

% Satellite mass
sat.mass = 4;
% Inertia Matrix
sat.Jx   = 0.003;
sat.Jy   = 0.007;
sat.Jz   = 0.008;
sat.Jxz  = 0;
sat.Jxy = 0;
sat.Jyz = 0;
sat.J = [sat.Jx,-sat.Jxy,-sat.Jxz;...
        -sat.Jxy,sat.Jy,-sat.Jyz;...
        -sat.Jxz,-sat.Jyz,sat.Jz];

%% Orbital Parameters

sat.alt = 500e3;    % Altitude
sat.Re = 6371e3;    % Radius of Earth
sat.Mu = 3.986e14;  % Standard Gravitational Parameter of Earth

sat.a = sat.Re + sat.alt;         % Semi-major axis
sat.e = 0;                        % Eccentricity
sat.i = deg2rad(97);              % Inclination
sat.RAAN = 0;                     % Right Accension of Ascending Node
sat.w = deg2rad(90);              % Argument of Periapsis
sat.ta = deg2rad(0);              % True Anomaly
sat.n = sqrt(sat.Mu/(sat.a)^3); % Mean Motion

%% Actuator Parameters

% Magnetorquers
mtq.Nx = 100;
mtq.Ax = 0.01;
mtq.Lx = 10;
mtq.Rx = 10;

mtq.Ny = 100;
mtq.Ay = 0.01;
mtq.Ly = 10;
mtq.Ry = 10;

mtq.Nz = 100;
mtq.Az = 0.01;
mtq.Lz = 10;
mtq.Rz = 10;

% Reaction Wheels


%% Sensor Parameters
% Inertial Measurement Unit
% Magnetometer
% Sun sensors
% GNSS Reciever
% Star Tracker

%% Initial Conditions

% omega B wrt O in B-frame
sat.p = 0;
sat.q = 0;
sat.r = 0;

% omega B wrt N in B-frame
sat.w1 = 0.0+sat.p;
sat.w2 = -sat.n+sat.q;
sat.w3 = 0.0+sat.r;
sat.omega = [sat.w1;sat.w2;sat.w3];