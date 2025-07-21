%% Shock-tube species profiles as a function of time
% Simulate species profiles for a shock tube as a function of time, and 
% observe the impact of incorporating the reduced-pressure linear mixture 
% rule (LMR-R) in such calculations.
%
% Here we predict the H2O mole fraction time profiles for a mixture of 1163
% ppm H2O2/1330 ppm H2O/665 ppm O2/20% CO2/Ar following reflected shock 
% waves (1196 K, 2.127 atm) and compare results against the experimental 
% measurements of Shao et al. [1] Two models are compared in this example:
%
% 1. A 2023 model of H2 and NH3 chemistry published by Alzueta et al. [2]
% 2. An adapted version of this model that has applied the reduced-pressure
% linear mixture rule (LMR-R) and ab initio third-body efficiencies. [3]
% References:
%
% [1] J. Shao, R. Choudhary, D. F. Davidson, R. K. Hanson, Shock tube/laser
% absorption measurement of the rate constant of the reaction: H2O2+CO2 = 
% 2OH+CO2, Proc. Combust. Inst. 39 (2023) 735 – 743.
%
% [2] M. U. Alzueta, I. Salas, H. Hashemi, P. Glarborg, CO-assisted NH3 
% oxidation, Combust. Flame 257 (2023) 112438.
%
% [3] P. J. Singal, J. Lee, L. Lei, R. L. Speth, M. P. Burke, 
% Implementation of New Mixture Rules Has a Substantial Impact on 
% Combustion Predictions for H2 and NH3, Proc. Combust. Inst. 40 (2024) 
% 105779.
%
% .. tags:: Matlab, shock tube, kinetics, combustion

clear all;
close all;

tic % total running time of the script
help shock_tube

file = 'example_data/ammonia-CO-H2-Alzueta-2023.yaml';
%% Models and colors
models = struct('Original', 'baseline', 'LMR_R', 'linear-Burke');
colors = struct('Original', [0.6, 0.6, 0.6], 'LMR_R', [0.5, 0, 0.5]); % grey and purple

results = struct();

%% Experimental data from Shao et al.
expData.t = [12.3, 20.3, 26.4, 39.6, 58.5, 79.2, 96.1, 113.8, 131.6, ...
             145.7, 161.2, 181.6, 195.3, 219.9, 237.2, 248.6, 262.4, ...
             272.2, 280.9];  % microseconds
expData.X_H2O = [1.47E-03, 1.59E-03, 1.66E-03, 1.78E-03, 1.98E-03, ...
                 2.06E-03, 2.15E-03, 2.22E-03, 2.26E-03, 2.30E-03, ...
                 2.39E-03, 2.38E-03, 2.40E-03, 2.42E-03, 2.47E-03, ...
                 2.53E-03, 2.51E-03, 2.50E-03, 2.47E-03];

%% Loop over mechanisms
model_names = fieldnames(models);
for k = 1:length(model_names)
    model_key = model_names{k};
    mech_name = models.(model_key);
    
    % Define mixture composition
    X_H2O2 = 1163e-6;
    X_H2O = 1330e-6;
    X_O2   = 665e-6;
    X_CO2  = 0.2 * (1 - X_H2O2 - X_H2O - X_O2);
    X_Ar   = 1 - X_CO2;

    gasComp = 'H2O2: 1163e-6, H2O: 1330e-6, O2: 665e-6, CO2: 0.1994, AR: 0.8006';

    gas = Solution(file, mech_name);
    gas.TPX = {1196, 2.127 * OneAtm, gasComp};

    r = Reactor(gas,'Reactor');
    r.energy = 'on';
    sim = ReactorNet({r});

    time = 0.0;
    estIgnDelay = 1.0; % seconds
    counter = 0;
    dt = 5.0e-7;
    
    time_data = [];
    H2O_X_data = [];

    while time < estIgnDelay
        time = time + dt;
        sim.advance(time);
        time = sim.time;
        if mod(counter, 10) == 0
            time_data(end+1) = time * 1e6;  % convert to µs
            H2O_X_data(end+1) = gas.moleFraction({'H2O'});
        end
        counter = counter + 1;
    end

    % Store results
    results.(model_key).t = time_data;
    results.(model_key).X_H2O = H2O_X_data;
end

%% Plotting
figure;
hold on;

for k = 1:length(model_names)
    model_key = model_names{k};
    plot(results.(model_key).t, 100 * results.(model_key).X_H2O, ...
         'LineWidth', 2, 'Color', colors.(model_key), 'DisplayName', strrep(model_key, '_', '-'));
end

plot(expData.t, 100 * expData.X_H2O, 'ko', 'MarkerSize', 6, ...
     'MarkerFaceColor', 'white', 'DisplayName', 'Shao et al.');

xlabel('Time [\mus]');
ylabel('H_2O Mole Fraction [%]');
legend('Location', 'southwest');
xlim([0 300]);
title('Ignition Simulation vs. Experiment');
grid on;


toc


