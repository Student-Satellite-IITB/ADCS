# Camera parameters
cam_fov = 60  # degrees
resolution = (640, 480)  # pixels (horizontal x vertical)
max_range = 2  # meters (working distance)

# Angular resolution per pixel (horizontal)
pixel_angular_resolution = cam_fov / resolution[0]  # degrees per pixel

# Jitter specification
jitter_peak = 0.1  # degrees
jitter_rms = jitter_peak / (2 ** 0.5)  # RMS jitter assuming sinusoid

# Error budget (RMS values in degrees)
theta_est_rms = 0.5
theta_ctrl_rms = 0.5

# Total RMS pointing error
theta_total_rms = (theta_est_rms**2 + theta_ctrl_rms**2 + jitter_rms**2) ** 0.5

# Conservative peak estimates (can be set to 3*sigma if needed)
theta_est_peak = 3*theta_est_rms  # or 3 * sigma
theta_ctrl_peak = 3*theta_ctrl_rms  # or 3 * sigma

# Total peak pointing error (worst-case sum of individual peaks)
theta_total_peak = theta_est_peak + theta_ctrl_peak + jitter_peak

# Requirement
theta_required = 1.0  # degrees

# Print results
print("---------------NOMINAL MODE POINTING ERROR ANALYSIS------------")
# print("Pixel angular resolution:", round(pixel_angular_resolution, 5), "deg/pixel")
print("Estimation Error (RMS):", theta_est_rms, "deg")
print("Control Error (RMS):", theta_ctrl_rms, "deg")
print("Jitter (RMS):", round(jitter_rms, 4), "deg")
print("Total Pointing Error (RMS):", round(theta_total_rms, 4), "deg")
print("Total Pointing Error (Worst-case):", round(theta_total_peak, 4), "deg")
print("Pointing Error Requirement:", theta_required, "deg")
print("RMS Margin:", round((theta_required - theta_total_rms) / theta_required * 100, 2), "%")