from math import pi, sqrt
from scipy.optimize import minimize

# Magnetorquer Rod Envelope Size
H = 15            # Rod height [mm]
L = 60            # Rod length [mm]
mass_max = 0.5    # Max mass [kg] 
# Mass is a soft constraint
# Therefor mass_max taken more than realistic on purpose to avoid mass constraint issues

# Bounds on solution space
Lmin = 20       # Minimum core length [mm]
Lmax = L
Rmin = 2.0      # Minimum core radius [mm]
Rmax = H / 2      # Max winding radius [mm]

# Core specifications
mu_0 = 4 * pi * 1e-7  # Permeability of free space [H/m]

mu_r = 2000           # Relative permeability
B_saturation = 1.2    # Saturation flux density [T]c
core_density = 7500  # Density of core material [kg/m^3]

# # Mu-metal
# mu_r = 500000           # Relative permeability
# B_saturation = 0.75    # Saturation flux density [T]c
# core_density = 7500  # Density of core material [kg/m^3]

# Electrical specifications
Pmax = 0.4        # Max power [W]
Vbus = 5.0        # Bus voltage [V]

# Wire specifications
# Discrete AWG wires: (diameter_mm, resistance_ohm_per_m)
AWG_TABLE = [
    (0.127, 0.151),  # AWG 36
    (0.143, 0.131),  # AWG 35
    (0.160, 0.115),  # AWG 34
    (0.180, 0.097),  # AWG 33
    (0.203, 0.080),  # AWG 32
    (0.229, 0.065),  # AWG 31
    (0.254, 0.052)   # AWG 30
]
PACKING_EFFICIENCY = 0.6    # Packing efficiency for winding
N_LAYERS_MAX = 5            # Max number of layers for winding
copper_density = 8960       # Density of copper [kg/m^3]

def sizing(Lcore, Rcore, dwire, rho, nlayers, I):
    """
    Calculate the magnetorquer design parameters.
    Parameters:
        Lcore (float): Length of the core [mm]  
        Rcore (float): Radius of the core [mm]
        dwire (float): Wire diameter [mm]
        rho (float): Resistance per meter of wire [ohm/m]
        nlayers (int): Number of winding layers
        I (float): Current [A]
    Returns:
        dict: Design parameters including magnetic moment, number of turns, wire length, resistance, voltage, and power.
    """

    # Convert to SI units
    Lcore = Lcore * 1e-3  
    Rcore = Rcore * 1e-3  
    dwire = dwire * 1e-3  

    # Winding calculations
    nturns_per_layer = round(PACKING_EFFICIENCY * (Lcore / dwire))  # Turns per layer
    N = nlayers * nturns_per_layer                                  # Total number of turns  
    R_avg = Rcore + (nlayers * dwire) / 2                           # Average radius of winding [m]
    wire_len = 2 * pi * R_avg * N                                   # Wire length [m]
    
    # Magnetic moment calculations
    Acore = pi * Rcore**2                                           # Core Area [m^2]
    Nd = 1/((2*(Lcore/Rcore)/sqrt(pi))+1)                           # Demagnetization factor

    M = N * I * Acore * (1 + ((mu_r - 1) / (1 + (mu_r - 1) * Nd)))  # Magnetic moment [A*m^2]

    H = N * I / Lcore                                               # Applied Magnetic field strength by coil [A/m]
    B = mu_0*(1 + ((mu_r - 1) / (1 + (mu_r - 1) * Nd)))*H           # Magnetic flux density [T] in core

    # Power calculations
    Resistance = rho * wire_len # [ohm]
    Voltage = I * Resistance    # [V]
    Power = I**2 * Resistance   # [W]

    # Mass calculations
    core_volume = Acore * Lcore  # Core volume [m^3]
    core_mass = core_volume * core_density  # Core mass [kg]
    wire_mass = wire_len * (pi*dwire**2 / 4) * copper_density  # Wire mass [kg]
    mass = core_mass + wire_mass  # Total mass [kg]

    return {
        'Lcore [mm]': Lcore * 1e3,  
        'Rcore [mm]': Rcore * 1e3,  
        'dwire [mm]': dwire * 1e3,  
        'nlayers': nlayers,
        'I [A]': I,
        'Turns per Layer': nturns_per_layer,
        'Total Turns': N,
        'Wire Length [m]': wire_len,
        'M [A*m^2]': M,
        'B [T]': B,
        'Resistance [ohm]': Resistance,
        'Voltage [V]': Voltage,
        'Power [W]': Power,
        'Mass [kg]': mass,
    }

# ========= OPTIMISER =================================

best_config = None
best_moment = -1

# Outer sweep over discrete variables: (AWG, nlayers)
for dwire, rho in AWG_TABLE:
    for nlayers in range(1, N_LAYERS_MAX+1):  # Discrete integer layers
        def objective(x):
            Lcore, Rcore, I = x
            result = sizing(Lcore, Rcore, dwire, rho, nlayers, I)
            return -result['M [A*m^2]']  # Maximize magnetic moment

        def constraint_radial(x):
            _, Rcore, _ = x
            return Rmax - (Rcore + nlayers * dwire)

        def constraint_power(x):
            Lcore, Rcore, I = x
            return Pmax - sizing(Lcore, Rcore, dwire, rho, nlayers, I)['Power [W]']

        def constraint_voltage(x):
            Lcore, Rcore, I = x
            return Vbus - sizing(Lcore, Rcore, dwire, rho, nlayers, I)['Voltage [V]']
        
        def constraint_mass(x):
            Lcore, Rcore, I = x
            return mass_max - sizing(Lcore, Rcore, dwire, rho, nlayers, I)['Mass [kg]']

        constraints = [
            {'type': 'ineq', 'fun': constraint_radial},
            {'type': 'ineq', 'fun': constraint_power},
            {'type': 'ineq', 'fun': constraint_voltage},
            {'type': 'ineq', 'fun': constraint_mass}
        ]

        x0 = [50, 4, 0.3]  # Initial guess: Lcore [mm], Rcore [mm], I [A]
        bounds = [
            (Lmin, Lmax),   # Lcore
            (Rmin, Rmax),     # Rcore
            (0.01, 1.0) # I
        ]

        res = minimize(objective, x0, bounds=bounds, constraints=constraints)

        if res.success:
            Lcore, Rcore, I = res.x
            result = sizing(Lcore, Rcore, dwire, rho, nlayers, I)
            M = result['M [A*m^2]']

            if M > best_moment:
                best_moment = M
                best_config = {
                    'x': res.x,  # Optimal parameters
                    'dwire': dwire,  # Wire diameter [mm]
                    'rho': rho,  # Resistance per meter [ohm/m]
                    'nlayers': nlayers,  # Number of layers
                }

# Display results

print("--------------------------------------------")
print("------ Optimal Magnetorquer Design ---------")
print("--------------------------------------------\n")

# Re-run sizing with the best solution
x = best_config['x']
dwire = best_config['dwire']
rho = best_config['rho']
nlayers = best_config['nlayers']
final_result = sizing(x[0], x[1], dwire, rho, nlayers, x[2])

# Printing design variables
print("-------- Design Variables ------")
print(f"Lcore: {x[0]:.2f} mm")
print(f"Rcore: {x[1]:.2f} mm")
print(f"dwire [mm]: {dwire}")
print(f"resistance_per_m [ohm/m]: {rho}")
print(f"nlayers: {nlayers}")
print(f"I: {x[2]:.3f} A")
print("------------------------------\n")

# Print clean results
for key, value in final_result.items():
    print(f"{key}: {value:.4f}" if isinstance(value, float) else f"{key}: {value}")



