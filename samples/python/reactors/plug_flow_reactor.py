"""
Nozzle with compressible flow
=====================================

This code snippet is to model a constant area and varying area (converging and diverging)
nozzle as Plug Flow Reactor with given dimensions and an incoming gas. 
The pressure is not assumed to be constant here, as opposed to the Python Version of 
the Plug Flow Reactor model.

The reactor assumes that the flow follows the Ideal Gas Law.

The governing equations used in this code (see :doc:`PFR_solver.m <PFR_solver>`)
can be found in:

    S.R. Turns. An Introduction to Combustion - Concepts and Applications,
    McGraw Hill Education, India, 2012, pp. 206-210.

The current example is written for methane combustion, but can be readily adapted 
for other chemistries. For additional details, see:

    A. Kumar, B. Hugger, and J.W. Meadows. Modelling of High-Pressure Combustion Rig
    with After-Burner and Supersonic Nozzle using Plug Flow Reactor Network Model. AIAA
    Propulsion and Energy 2020 Forum. https://doi.org/10.2514/6.2020-3893

.. tags:: Python, combustion, user-defined model, compressible flow, plotting
"""

import cantera as ct
import numpy as np
from scipy.integrate import solve_ivp
import matplotlib.pyplot as plt

# Initialization
T0 = 1473  # K
P0 = 4.47 * 101325  # Pa
Phi = 0.2899

# Load gas object
gas = ct.Solution('gri30.yaml')
ich4 = gas.species_index('CH4')
io2 = gas.species_index('O2')
in2 = gas.species_index('N2')

# Set composition
x = np.zeros(gas.n_species)
x[ich4] = Phi
x[io2] = 2.0
x[in2] = 7.52
gas.TPX = T0, P0, x
gas.equilibrate('HP')

# Reactor geometry
A_in = 0.018  # m^2
A_out = 0.003  # m^2
L = 1.284 * 0.0254  # m
n = 100
mdot = 1.125  # kg/s

# Determine nozzle shape
if A_in > A_out:
    k = -1
elif A_out > A_in:
    k = 1
else:
    k = 0

dAdx = abs(A_in - A_out) / L
dx = L / n
x_calc = np.linspace(0, L, n + 1)

# Initialize results
T_calc = np.zeros(n + 1)
rho_calc = np.zeros(n + 1)
Y_calc = np.zeros((n + 1, gas.n_species))

T_calc[0] = gas.T
rho_calc[0] = gas.density
Y_calc[0, :] = gas.Y

# ODE System: Compressible PFR solver
def pfr_solver(x, y, gas, mdot, A_in, dAdx, k):
    rho = y[0]
    T = y[1]
    Y = y[2:]

    if k == 1:
        A = A_in + k * dAdx * x
    elif k == -1:
        A = A_in + k * dAdx * x
        dAdx = -dAdx
    else:
        A = A_in + k * dAdx * x
    
    # the gas is set to the corresponding properties during each iteration of the ode loop
    gas.TDY = T, rho, Y
    mw = gas.mean_molecular_weight
    ru = ct.gas_constant
    R = ru / mw
    nsp = gas.n_species
    vx = mdot / (rho * A)
    P = rho * R * T

    gas.basis = 'mass'
    MW = gas.molecular_weights
    h = gas.partial_molar_enthalpies
    w = gas.net_production_rates
    Cp = gas.cp_mass
    """--------------------------------------------------------------------------
    ---drhodx, dTdx and dYdx are the differential equations modelling the---
    ---density, temperature and mass fractions variations along a plug flow---
    -------------------------reactor------------------------------------------
    --------------------------------------------------------------------------"""

    drhodx = ((1 - R / Cp) * ((rho * vx)**2) * (1 / A) * (dAdx) + rho * R * np.sum(MW * w * (h - mw * Cp * T / MW)) / (vx * Cp)) / (P * (1 + vx**2 / (Cp * T)) - rho * vx**2)
    dTdx = (vx * vx / (rho * Cp)) * drhodx + vx * vx * (1 / A) * (dAdx) / Cp - (1 / (vx * rho * Cp)) * np.sum(h * w * MW)
    dYdx = w * MW / (rho * vx)
    return np.hstack([drhodx, dTdx, dYdx])

# Integration
for i in range(1, len(x_calc)):
    y0 = np.hstack([rho_calc[i - 1], T_calc[i - 1], Y_calc[i - 1, :]])
    sol = solve_ivp(pfr_solver, [x_calc[i - 1], x_calc[i]], y0,
                    args=(gas, mdot, A_in, dAdx, k),
                    method='BDF', rtol=1e-10, atol=1e-10)

    rho_calc[i] = sol.y[0, -1]
    T_calc[i] = sol.y[1, -1]
    Y_calc[i, :] = sol.y[2:, -1]

# Post-processing
A_calc = A_in + k * x_calc * dAdx
vx_calc = mdot / (A_calc * rho_calc)
R_calc = ct.gas_constant / gas.mean_molecular_weight
P_calc = rho_calc * R_calc * T_calc
M_calc = np.zeros(len(x_calc))

for i in range(len(x_calc)):
    gas.TDY = T_calc[i], rho_calc[i], Y_calc[i, :]
    M_calc[i] = vx_calc[i] / gas.sound_speed

# Plotting
plt.figure()
plt.plot(x_calc, M_calc)
plt.xlabel('X-Position (m)')
plt.ylabel('Mach Number')
plt.title('Mach Number Variation')

plt.figure()
plt.plot(x_calc, A_calc)
plt.xlabel('X-Position (m)')
plt.ylabel('Area (m²)')
plt.title('Reactor Profile')

plt.figure()
plt.plot(x_calc, T_calc)
plt.xlabel('X-Position (m)')
plt.ylabel('Temperature (K)')
plt.title('Temperature Variation')

plt.figure()
plt.plot(x_calc, rho_calc)
plt.xlabel('X-Position (m)')
plt.ylabel('Density (kg/m³)')
plt.title('Density Variation')

plt.figure()
plt.plot(x_calc, P_calc)
plt.xlabel('X-Position (m)')
plt.ylabel('Pressure (Pa)')
plt.title('Pressure Variation')

plt.show()
