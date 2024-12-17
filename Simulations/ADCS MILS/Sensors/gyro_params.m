%% GYRO PARAMETERS

% Author: Ameya Marakarkandy
% Last Updated: 05/09/2024
%
% @brief 
% Initialises parameters needed for
% Gyroscope model

%% DATASHEET PARAMETERS

gyro.FullScale = 250;
gyro.staticBias = 0.1;
gyro.Sensitivity = 2^15/gyro.FullScale;
gyro.NoiseSpectralDensity = 0.005; % At 10Hz
gyro.SatLimit = gyro.FullScale*gyro.Sensitivity;
gyro.UpdateRate = 100;




