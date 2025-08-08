%% Vapor Dome
% This example generates a saturated steam table and plots the vapor dome.
% The steam table corresponds to data typically found in thermodynamic text
% books and uses the same customary units
%
% .. tags:: Matlab, thermodynamics, non-ideal fluid, plotting

clear all
close all

tic
help vapor_dome


w = Water;
w.basis = {'mass'};

%% Temperature vector in degC
degC = [w.minTemp - 273.15, 4, 5, 6, 8, ...
        10:36, 38, ...
        40:5:95, 100:10:290, ...
        300:20:360, 370:1:373, ...
        w.critTemperature - 273.15];

T_vec = degC + 273.15;
n = length(T_vec);

%% Preallocate arrays
T = zeros(n,1); P = zeros(n,1);
vf = zeros(n,1); vg = zeros(n,1); vfg = zeros(n,1);
uf = zeros(n,1); ug = zeros(n,1); ufg = zeros(n,1);
hf = zeros(n,1); hg = zeros(n,1); hfg = zeros(n,1);
sf = zeros(n,1); sg = zeros(n,1); sfg = zeros(n,1);

%% Loop through temperatures and get saturated liquid/vapor properties
for i = 1:n
    T_i = T_vec(i);
    T(i) = T_i - 273.15;

    % Saturated vapor
    w.TQ = {T_i, 1};
    vg(i) = w.V;
    ug(i) = w.U/1e3;
    hg(i) = w.H/1e3;
    sg(i) = w.S/1e3;

    % Saturated liquid
    w.TQ = {T_i, 0};
    vf(i) = w.V;
    uf(i) = w.U/1e3;
    hf(i) = w.H/1e3;
    sf(i) = w.S/1e3;

    % Pressure (same for both states)
    P(i) = w.P/1e5;
end

%% Delta values
vfg = vg - vf;
ufg = ug - uf;
hfg = hg - hf;
sfg = sg - sf;

%% Reference state: triple point liquid
w.TQ = {w.minTemp, 0};
uf0 = w.U/1e3;
hf0 = w.H/1e3;
sf0 = w.S/1e3;
pv0 = w.P * w.V/1e3;

%% Adjust reference state
uf = uf - uf0;
ug = ug - uf0;
hf = hf - hf0 + pv0;
hg = hg - hf0 + pv0;
sf = sf - sf0;
sg = sg - sf0;

%% Print and write saturated steam table to csv file
data = table(T, P, vf, vfg, vg, uf, ufg, ug, hf, hfg, hg, sf, sfg, sg);
disp(data);
writetable(data, 'saturated_steam_T.csv');
%% Plot P-v Diagram
figure;
semilogx(vf, P, 'b', 'LineWidth', 1.5); hold on;
semilogx(vg, P, 'r', 'LineWidth', 1.5);
plot(vg(end), P(end), 'ko', 'MarkerFaceColor', 'w');
xlabel('Specific Volume v [m^3/kg]');
ylabel('Pressure P [bar]');
legend('Saturated Liquid', 'Saturated Vapor', 'Critical Point');
title('Vapor Dome - P-v Diagram');
grid on;

%% Plot T-s Diagram
figure;
plot(sf, T, 'b', 'LineWidth', 1.5); hold on;
plot(sg, T, 'r', 'LineWidth', 1.5);
plot(sg(end), T(end), 'ko', 'MarkerFaceColor', 'w');
xlabel('Specific Entropy s [kJ/kg-K]');
ylabel('Temperature T [°C]');
legend('Saturated Liquid', 'Saturated Vapor', 'Critical Point');
title('Vapor Dome - T-s Diagram');
grid on;
