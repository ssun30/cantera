%% Non-ideal equations of state
%
% This example demonstrates a comparison between ideal and non-ideal equations of
% state (EoS) using Cantera.
%
% The following equations of state are used to evaluate thermodynamic properties
% in this example:
%
% 1. Ideal-gas EoS from Cantera
% 2. Non-ideal Redlich-Kwong EoS (R-K EoS) from Cantera
%
% .. tags:: Matlab, thermodynamics, non-ideal fluid

clear all
close all

tic
help equations_of_state

%% Helper Functions
% This examples uses \mathrm{ CO_2 } as the only species. The function
% "get_thermo_Cantera" calculates thermodynamic properties based on the
% thermodynamic state (T, p) of the species using Cantera. Applicable phases
% are "Ideal-gas" and "Redlich-Kwong". The ideal-gas equation can be stated
% as
%
% .. math:: 
%     \mathrm{ pv = RT },
%
% where p, v, and T represent thermodynamic pressure, molar volume, and the
% temperature of the gas-phase. R is the universal gas constant. The
% Redlich-Kwong equation is a cubic, non-ideal equation of state,
% represented as
%
% .. math::
%     \mathrm{ p = \frac{RT}{v-b^\ast}-\frac{a^\ast}{v\sqrt{T}(v+b^\ast)} }.
%
% In this expression, R is the universal gas constant and v is the molar
% volume. The temperature-dependent van der Waals attraction parameter
% \mathrm{ a^\ast } and volume correction parameter (repulsive parameter)
% \mathrm{ b^\ast } represent molecular interactions.
%
% To plot the comparision of thermodynamic properties among the tree EoS,
% the "plotEoS" function is used.

function [h, u, s, cp, cv] = get_thermo_Cantera(phase, T, p)
    phase.basis = {'mass'};
    n = length(p);
    u = zeros(1, n);
    h = zeros(1, n);
    s = zeros(1, n);
    cp = zeros(1, n);
    cv = zeros(1, n);

    for i = 1:n
        phase.TPX = {T, p(i), 'CO2:1.0'};
        u(i) = phase.U / 1000;
        h(i) = phase.H / 1000;
        s(i) = phase.S / 1000;
        cp(i) = phase.cp / 1000;
        cv(i) = phase.cv / 1000;
    end

    % Reference to first point
    u = u - u(1);
    h = h - h(1);
    s = s - s(1);
end

function plotEoS(p, ideal, rk, y_label)
    figure;
    plot(p / 1e5, ideal, 'b-', 'LineWidth', 2); 
    hold on;
    plot(p / 1e5, rk, 'r-', 'LineWidth', 2);
    xlabel('Pressure [bar]');
    ylabel(y_label);
    legend('Ideal EoS', 'R-K EoS');
    grid on;
end

%% EoS Comparison based on thermodynamic properties
%
% This is th emain subroutine that compares the plots and thermodynamic
% values obtained using three equations of state.

% Input parameters
T = 300; % K
p = 1e5 * linspace(1, 100, 1000); % Pa

% Read the ideal-gas phase
idealGasPhase = Solution('example_data/co2-thermo.yaml', 'CO2-Ideal');
[h_ideal, u_ideal, s_ideal, cp_ideal, cv_ideal] = get_thermo_Cantera(idealGasPhase, T, p);

% Read the Redlich-Kwong phase
redlichKwongPhase = Solution('example_data/co2-thermo.yaml', 'CO2-RK');
[h_RK, u_RK, s_RK, cp_RK, cv_RK] = get_thermo_Cantera(redlichKwongPhase, T, p);

% Plot the results
plotEoS(p, u_ideal, u_RK, "Relative Internal Energy [kJ/kg]");
plotEoS(p, h_ideal, h_RK, "Relative Enthalpy [kJ/kg]"); 
plotEoS(p, s_ideal, s_RK, "Relative Entropy [kJ/kg-K]");

%%
% The thermodynamic properties such as internal energy, enthalpy, and 
% entropy are plotted against the operating pressure at a constant 
% temperature T = 300 K. The three equations follow each other closely at low 
% pressures (P < 10bar). However, the ideal gas EoS departs significantly 
% from the observed behavior of gases near the critical regime 
% (Pcrit = 73.77 bar).
%
% The ideal gas EoS does not consider inter-molecular interactions and the 
% volume occupied by individual gas particles. At low temperatures and high
% pressures, inter-molecular forces become particularly significant due to 
% a reduction in inter-molecular distances. Additionally, at high density, 
% the volume of individual molecules becomes significant. Both of these 
% factors contribute to the deviation from ideal behavior at high pressures. 
% The cubic Redlich-Kwong EoS, on the other hand, predicts thermodynamic 
% properties accurately near the critical regime.

% Specific heat at constant pressure 
plotEoS(p, cp_ideal, cp_RK, "C_p [kJ/kg-K]");
% Specific heat at constant volume
plotEoS(p, cv_ideal, cv_RK, "C_v [kJ/kg-K]");
%%
% In the case of Ideal gas EoS, the specific heats at constant pressure
% (Cp) and constant volume (Cv) are independent of the pressure. Hence, Cp
% and Cv for ideal EoS do not change as the pressure is varied from 1 bar
% to 100 bar in this study.
%
% Cp for the R-K EoS follows the trend closely with the Helmholtz EoS from
% CoolProp up to the critical regime. Alhtough Cp shows reasonable
% agreement with the Helmholtz EoS in sub-critical and supercritical
% reginmes, it inaccurately predicts a very high value near the critical
% point. However, Cp at the critical point is finite for the real fluid.
% The sudden rise in Cp in the case of the R-K EoS is just a numerical
% artifact, due to the EoS yielding infinite values in the limiting case,
% and not a real singularity.
%
% Cv, on the other hand, predicts smaller values in the subcritical and
% critical regime. However, it shows completely incorrect values in the
% super-critical region, making it invalid at very high pressures. It is
% well known that the cubic equations typically fail to predics accurate
% constant-volume heat capacity in the transcritical region [2]_. Certain
% cubic EoS models have been extended to resolve the discrepancy using
% crossover models. For further information sese the work of Span [2]_ and
% Saeed et al. [3]_.

%% Temperature-Density plots
%
% The following function plots the T-'rho' diagram over a wide pressure and
% temperature range. The temperature is varied from 250 K to 400 K. The
% pressure is changed from 1 bar to 600 bar.

% Input parameters
% Set up arrays for pressure and temperature
p_arr = logspace(1, log10(600), 10);
T_arr = linspace(250, 401, 20);
p_arr = 1e5 * p_arr(:);

% Initialize matrices to hold densities
density_ideal = zeros(length(p_arr), length(T_arr));
density_RK = zeros(length(p_arr), length(T_arr));
%density_CP = zeros(length(p_arr), length(T_arr));

% Loop over pressure and temperature to compute densities
for i = 1:length(p_arr)
    for j = 1:length(T_arr)
        T = T_arr(j);
        P = p_arr(i);

        % Ideal gas
        idealGasPhase.TP = {T, P};
        density_ideal(i, j) = idealGasPhase.D;

        % Redlich-Kwong gas
        redlichKwongPhase.TP = {T, P};
        density_RK(i, j) = redlichKwongPhase.D;

    end
end

% Plotting
figure;
hold on;
colors = parula(length(p_arr));

for i = 1:length(p_arr)
    % Ideal gas lines (dashed)
    ideal_line = plot(density_ideal(i,:), T_arr, '--', 'Color', colors(i,:), 'HandleVisibility', 'on');
    % RK EoS lines (circles)
    RK_line = plot(density_RK(i,:), T_arr, 'o', 'Color', colors(i,:), 'HandleVisibility', 'on');
end
xlabel('Density [kg/m^3]');

ylabel('Temperature [K]');
legend([ideal_line(1), RK_line(1)], {"Ideal EoS", "R-K EoS"}, 'Location', 'northeast'); 
title('T vs Density for CO2 at Various Pressures');
grid on;

% Text annotations
text(30, 320, 'p = 1 bar', 'Color', colors(1,:), 'Rotation', 90);
text(430, 318, 'p = 97 bar', 'Color', colors(6,:), 'Rotation', -12);
text(960, 320, 'p = 600 bar', 'Color', colors(10,:), 'Rotation', -68);

toc
%%
% The figure compares T-\rho plots for ideal, R-K, and Helmholtz EoS at
% different operating pressures. All three EoS yield the same plots at low pressures (0
% bar and 10 bar). However, the Ideal gas EoS departs significantly at high pressures
% (P > 10 bar), where non-ideal effects are prominent. The R-K EoS closely
% matches the Helmholtz EoS at supercritical pressures (P > 70 bar). However,
% it does depart in the liquid-vapor region that exists at P < P_crit
% and low temperatures (T_crit).
%
% .. [1] I.H. Bell, J. Wronski, S. Quoilin, V. Lemort, "Pure and Pseudo-pure Fluid
%    Thermophysical Property Evaluation and the Open-Source Thermophysical Property
%    Library CoolProp," Industrial & Engineering Chemistry Research 53 (2014),
%    https://pubs.acs.org/doi/10.1021/ie4033999
%
% .. [2] R. Span, "Multiparameter Equations of State - An Accurate Source of
%    Thermodynamic Property Data," Springer Berlin Heidelberg (2000),
%    https://dx.doi.org/10.1007/978-3-662-04092-8
%
% .. [3] A. Saeed, S. Ghader, "Calculation of density, vapor pressure and heat capacity
%    near the critical point by incorporating cubic SRK EoS and crossover translation,"
%    Fluid Phase Equilibria (2019) 493, https://doi.org/10.1016/j.fluid.2019.03.027
%
% sphinx_gallery_thumbnail_number = -1
