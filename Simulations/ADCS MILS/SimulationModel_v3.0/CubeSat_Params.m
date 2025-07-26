%% CUBESAT Parameters

% Author: Ameya Marakarkandy
% Last Updated: 24/07/2025
%
% @brief 
% Initialises parameters needed for
% CubeSat Simulation Model

%% Physical parameters

% Satellite mass
sat.mass = 4.5;
% Inertia Matrix
sat.Jx = 0.035;
sat.Jy = 0.035;
sat.Jz = 0.0075;
sat.Jxz = 0;
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
sat.i = deg2rad(90);              % Inclination
sat.RAAN = 0;                     % Right Accension of Ascending Node
sat.w = deg2rad(90);              % Argument of Periapsis
sat.ta = deg2rad(0);              % True Anomaly
sat.n = sqrt(sat.Mu/(sat.a)^3);   % Mean Motion
sat.T = 2*pi/sat.n;

%% Actuator Parameters

% Reaction Wheels
% Reaction Wheel Inertia about axis
Js = 9e-6;
ws0 = 0; % Initial wheel speed
% 3-axis configuration
A = eye(3); % aligned with body axis

% Tetrahedral configuration
% B = deg2rad(30);
% A = [sin(B),0,-sin(B),0;
%     0,sin(B),0,-sin(B);
%     cos(B),cos(B),cos(B),cos(B)];

%% Initial Conditions

% Initial Attitude
initAngle = deg2rad(0);
initAxis = [0;0;0];
sat.quat = [cos(initAngle/2);sin(initAngle/2)*initAxis];
%sat.quat = [0;0;1;0];

% Initial Angular Rate
% omega B wrt N in B-frame
sat.omegaBN = [0;0;0];