function results = run_calibration(time_ode_train, X0_train, juveniles_train, adult_fems_train, T_ode_train, selected_parameters_indices)

% Input: - time_ode_train (array): monthly time grid for the training period [months]
%     - X0_train (array): initial state [J0, A0] for the training period [#crabs/1000m²]
%     - juveniles_train (array): observed juvenile densities over the training years [#crabs/1000m²]
%     - adult_fems_train (array): observed adult female densities over the training years [#crabs/1000m²]
%     - T_ode_train (array): temperature time series over the training period [°C]
%     - selected_parameters_indices (array): indices of the parameters to calibrate (0–7)
% 
% Output: - results (struct) with keys: - params_est (array): all Pareto-optimal parameter sets
%                                     - pareto_front (array): corresponding objective values [mse_J, mse_A]
%                                     - distance_from_origin (array): Euclidean distance of each Pareto point from the origin
%                                     - params_est_struct (struct): struct with keys params_est, pareto_front, distance_from_origin
%                                     - opt_index (int): index of the selected optimal solution
%                                     - params_opt (array): optimal parameter vector
%                                     - opt_cost (array): objective values at the optimal solution
%                                     - cost0 (array): objective values at the nominal parameters
%                                     - lb (array): lower bounds used for calibration
%                                     - ub (array): upper bounds used for calibration
%                                     - selected_parameters_indices (array): as provided in input
%                                     - calibration_elapsed_time (float): computation time [seconds]
% 
% Runs multi-objective calibration using NSGA-II. Only the parameters at selected_parameters_indices are optimized, 
% their bounds are set to ±80% of the nominal values. The optimal solution
% is the Pareto point with minimum distance from the origin.

%% initial parameters and bounds

params0 = [20,... p, predator density [#crabs/(1000m^2)]
    3,... x, prey density at 0.5 k_max [#crabs/(1000m^2)]
    30.62/12,... alpha, maximum per capita reproduction rate [1/months]
    0.01256,... b, density-dependent effect on reproduction [(1000m^2/#crabs)^2]
    0.9/12,... m, adult mortality rate [1/months]
    1,... beta_RR, maturation rate of juveniles to be multiplied by resp_rate [RR/months]
      ... beta = 0.0908 => anche beta_RR*resp_rate deve stare lì intorno => beta_RR = 1
    1/15.7,... r_T, parametro per collegare recruitment a temperatura [1/°C]
           ... tra 1/T_max e 1/T_min (T_max = 29.3°C, T_min = 0.8°C, mean(T_ode) = 15.7°C)
    0.294/12]; % f_l, linear fishing mortality rate [1/months]
% bounds
lb = params0;
lb(selected_parameters_indices) = 0.2*params0(selected_parameters_indices);
ub = params0;
ub(selected_parameters_indices) = 1.8*params0(selected_parameters_indices);

cost0 = simulate_and_compare(params0, time_ode_train, X0_train, juveniles_train, adult_fems_train, T_ode_train);
%% optimization

objective = @(params) simulate_and_compare(params, time_ode_train, X0_train, juveniles_train, adult_fems_train, T_ode_train);

% minimization
tic
options = optimoptions('gamultiobj','MaxGenerations',200,'CrossoverFraction',0.7,'FunctionTolerance',1e-3);
params_est = gamultiobj(objective,size(ub,2),[],[],[],[],lb,ub,[],options); % pareto solutions (estimated parameters)
elpased_time_calibration = toc;

pareto_front = zeros(length(params_est),2); % pareto front (objective values outputs)
distance_from_origin = zeros(length(params_est),1); % distance from origin of each estimated parameter on pareto front
% for each estimated set of parameters store the parameters values, the corresponding objective function value ( = cost)
% and its distance from the origin
params_est_struct = struct();
for i = 1:length(params_est)
    pareto_front(i,:) = objective(params_est(i,:));
    params_est_struct(i,:).params = params_est(i,:);
    params_est_struct(i,:).pareto_front = pareto_front(i,:);
    params_est_struct(i,:).distance_from_origin = norm(pareto_front(i,:));
    distance_from_origin(i) = norm(pareto_front(i,:));
end

[~, opt_index] = min(distance_from_origin);
params_opt = params_est(opt_index,:);
opt_cost = pareto_front(opt_index,:);

disp('calibration elapsed time = '+ string(elpased_time_calibration) + ' s')

%% pack results

 results = struct(params_est = params_est,...
             pareto_front = pareto_front,...
             distance_from_origin = distance_from_origin,...
             params_est_struct = params_est_struct,...
             opt_index = opt_index,...
             params_opt = params_opt,...
             opt_cost = opt_cost,...
             cost0 = cost0,...
             ub = ub,...
             lb = lb,...
             selected_parameters_indices = selected_parameters_indices,...
             elpased_time_calibration = elpased_time_calibration);

end