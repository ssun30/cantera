%% Critical state properties
% Print the critical state properties for the fluids for which Cantera has 
% built-in liquid/vapor equations of state.
%
% .. tags:: Matlab, thermodynamics, multiphase, non-ideal fluid

clear all;
close all;

tic % total runtime of script
help crit_properites

%% Create a pure fluid object
fluids = struct('water', Water(), ...
    'nitrogen', Nitrogen(), ...
    'methane', Methane(), ...
    'hydrogen', Hydrogen(), ...
    'oxygen', Oxygen(), ...
    'carbon_dioxide', CarbonDioxide(), ...
    'heptane', Heptane(), ...
    'HFC_134a', HFC134a());

names = fieldnames(fluids);

%% Plot critical properties and print tabulated values

figure;
hold on;
title('Critical Properties of Pure Fluids');
xlabel('Critical Temperature [K]');
ylabel('Critical Pressure [Pa]');
xlim([0 750]);
grid on;

% Print header
fprintf('Critical State Properties\n');
fprintf('%-16s   %-7s   %-10s   %-7s\n', 'Fluid', 'Tc [K]', 'Pc [Pa]', 'Zc');
fprintf('%s   %s   %s   %s\n', repmat('-',1,16), repmat('-',1,7), repmat('-',1,10), repmat('-',1,7));

% Loop through fluids
for i = 1:length(names)
    name = names{i};
    f = fluids.(name);

    Tc = f.critTemperature;
    Pc = f.critPressure;
    rhoc = f.critDensity;
    mw = f.meanMolecularWeight;
    R = GasConstant;

    Zc = Pc * mw / (rhoc * R * Tc);

    % Plot
    plot(Tc, Pc, 'o');
    text(Tc + 4, Pc + 2e5, strrep(name, '_', ' '), 'FontSize', 9);

    % Print table row
    fprintf('%-16s   %7.2f   %10.4g   %7.4f\n', strrep(name, '_', ' '), Tc, Pc, Zc);
end

toc