function q_opt = QMethod(varargin)
% QMethod: Implementation of Davenport's Q-Method
%   Computes optimal quaternion estimate from 
%   mutiple observation vectors from sensors
%   
%   Inputs:
%   wk Weight for kth measurement
%   vkB kth measurement vector in body frame
%   vkN kth measurement vector in inertial frame

if nargin < 3
    error('Atleast 2 sets of vectors are required')
end

% Normalisation of inputs
for i = 1:nargin
    varargin{i} = varargin{i}/norm(varargin{i});
end

% Computing B matrix
B = zeros(3);
for i = 0:nargin/3-1
        B = B + varargin{3*i+1}*varargin{3*i+2}*varargin{3*i+3}';
end

S = B + B';

sigma = trace(B);

Z = [B(2,3)-B(3,2);
    B(3,1)-B(1,3);
    B(1,2)-B(2,1)];

K = [sigma,Z';
    Z,S-sigma*eye(3)];

[V, ~] = eig(K);
% Find index of max eigenvalue
[~, i] = max(eig(K));
% Extract corresponding eigenvector
q_opt = V(:, i);

if q_opt(1)<0
    q_opt = -q_opt;
end