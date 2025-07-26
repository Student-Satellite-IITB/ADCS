function R = TRIAD(r1B,r1N,r2B,r2N)
% TRIAD: Implementation of TRIAD Algorithm
%   Computes DCM from intertial to body frame using
%   2 vector measurements in body frame and
%   their inertial frame representations using model (from propagator)
%
%   Inputs:
%   r1N vector1 in inertial frame from model
%   r2N vector2 in inertial frame from model
%   r1B vector1 measurement in body frame 
%   r2B vector2 measurement in body frame
%
%   NOTE: r1B is the more accurate measurement

% Normalisation of inputs
r1N = r1N/norm(r1N);
r2N = r2N/norm(r2N);
r1B = r1B/norm(r1B);
r2B = r2B/norm(r2B);

t1N = r1N;
t2N = cross(r1N,r2N)/norm(cross(r1N,r2N));
t3N = cross(t1N,t2N);

t1B = r1B;
t2B = cross(r1B,r2B)/norm(cross(r1B,r2B));
t3B = cross(t1B,t2B);

% RBN = RBT*(RNT)^T
R = [t1B,t2B,t3B]*[t1N,t2N,t3N]';
end