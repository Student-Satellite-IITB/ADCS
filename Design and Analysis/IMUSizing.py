import numpy as np
import matplotlib.pyplot as plt

# === User Inputs ===
max_3sigma_angle_deg = 0.1      # Maximum allowable 3-sigma attitude error in degrees
T_required_s = 45               # Required time in seconds without aiding measurements

# Convert to 1-sigma angle error
sigma_theta_deg = max_3sigma_angle_deg / 3

# Compute allowable ARW
max_arw_deg_sqrtHz = sigma_theta_deg / np.sqrt(T_required_s)
max_arw_mdps_sqrtHz = max_arw_deg_sqrtHz * 1000  # Convert to mdps/sqrt(Hz)

print(f"\nARW Requirement Analysis")
print(f"For attitude accuracy <= {max_3sigma_angle_deg} deg (3-sigma) over {T_required_s} seconds:")
print(f"  1-sigma allowable angle error: {sigma_theta_deg:.4f} deg")
print(f"  Max allowable ARW: {max_arw_mdps_sqrtHz:.2f} mdps/sqrt(Hz)\n")

# Time range for visualization
t_range = np.linspace(1, 120, 500)
allowable_arw = (max_3sigma_angle_deg / 3) / np.sqrt(t_range) * 1000  # mdps/sqrt(Hz)

# Plotting
plt.figure(figsize=(8, 5))
plt.plot(t_range, allowable_arw, label='Allowable ARW for 0.1 deg (3-sigma)', color='blue', linewidth=2)
plt.axvline(T_required_s, linestyle='--', color='gray')
plt.axhline(max_arw_mdps_sqrtHz, linestyle='--', color='red')

# Annotate T and ARW
plt.text(T_required_s + 2, allowable_arw[0] * 0.9,
         f"T = {T_required_s} s\nMax ARW = {max_arw_mdps_sqrtHz:.2f} mdps/sqrt(Hz)",
         color='black', fontsize=10, bbox=dict(facecolor='white', edgecolor='gray'))

# Labels
plt.title("Allowable Gyroscope ARW vs Propagation Time")
plt.xlabel("Propagation Time Without Aiding (s)")
plt.ylabel("Allowable ARW (mdps/sqrt(Hz))")
plt.grid(True)
plt.legend()
plt.tight_layout()
plt.show()
