from math import pi

# --- Inputs ---
t_maneuver = 30      # total maneuver time [s]
Jy = 0.03            # Moment of inertia about axis [kg·m²]
theta_deg = 90       # Slew angle [deg]
w_maneuver = 4       # chosen angular velocity during coast phase [deg/s]

# --- Limits (Informative) ---
wmax_deg = 2 * theta_deg / t_maneuver
wmin_deg = theta_deg / t_maneuver

# --- Derived ---
t_coast = 2 * theta_deg / w_maneuver - t_maneuver
alpha_deg = 4 * theta_deg / (t_maneuver**2 - t_coast**2)  # [deg/s²]
alpha_rad = alpha_deg * (pi / 180)                       # [rad/s²]
torque = Jy * alpha_rad                                  # [Nm]

# --- Output ---
print(f"Maneuver time: {t_maneuver} s")
print(f"Chosen coast angular rate: {w_maneuver:.2f} deg/s")
print(f"Computed coast time: {t_coast:.2f} s")
print(f"Required angular acceleration: {alpha_deg:.2f} deg/s^2")
print(f"Required torque: {torque*1e3:.2f} mNm")  # convert to mNm

H_capacity_mNms = 5.7
# Convert w_maneuver to rad/s
w_maneuver_rad = w_maneuver * pi / 180
# Approximate wheel momentum required (assuming zero net initial momentum)
H_wheel = Jy * w_maneuver_rad   # [N·m·s] = [kg·m²·rad/s]
# Convert to mN·m·s for convenience
H_wheel_mNms = H_wheel * 1e3

print(f"Coasting wheel momentum: {H_wheel_mNms:.3f} mNms")
print(f"{(H_wheel_mNms/H_capacity_mNms)*1e2:.2f} % Momemtum capacity of wheel during coast ")