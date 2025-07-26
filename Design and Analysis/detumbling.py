# detumbling.py
# Detumbling simulation using magnetic dipole feedback control
# 1-axis rotation around z-axis
# Constant magnetic field in orbital frame


from math import *
import numpy as np
import matplotlib.pyplot as plt

wi = radians(5)
wf = radians(0.2)
B = 25e-6
Jz =  0.14
m_x = 0.4 # Magnetic dipole moment [A*m^2]
m_y = 0.4 # Magnetic dipole moment [A*m^2]
td = 3*60*60 # Desired maximum detumbling time [s] 3 hours (~2 orbits)

def wdot(J,T):
    wdot = T/J
    return wdot

# Time parameters
dt = 0.1  # time step [s]
t_final = td # total simulation time [s]
time = np.arange(0, t_final, dt)
# Store results
w_history = []
m_y_history = []
m_x_history = []

# Simulation loop
w = wi
k = 10

for t in time:
    m_y = k*w # Feedback control law
    m_x = k*w
    m_y = np.clip(m_y, -0.4, 0.4)  # Limit magnetic dipole moment
    m_x = np.clip(m_x, -0.4, 0.4)  # Limit magnetic dipole moment
    
    Bx = B*cos(w*t)
    By = -B*sin(w*t)
    Bz = 0
    
    w =  w + wdot(Jz, -m_y*Bx + m_x*By) * dt
    m_y_history.append(m_y)
    m_x_history.append(m_x) 
    w_history.append(w)

# --- Plot ---
plt.figure()
plt.plot(time, w_history, label='ω_z [deg/s]')
plt.plot(time, 0 * np.ones_like(time), 'k--', label='ω_z = 0')
plt.plot(time, wf * np.ones_like(time), 'b--', label='ω_z = 2deg/s')
plt.xlabel('Time [s]')
plt.ylabel('Angular velocity z [rad/s]')

plt.figure()
plt.plot(time, m_y_history, label='m_y [A*m^2]')
plt.xlabel('Time [s]')
plt.ylabel('Magnetic dipole moment y [A*m^2]')

plt.figure()
plt.plot(time, m_x_history, label='m_x [A*m^2]')
plt.xlabel('Time [s]')  
plt.ylabel('Magnetic dipole moment x [A*m^2]')

plt.show()

