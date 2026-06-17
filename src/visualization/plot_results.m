function plot_results(T_ode_train, time_ode_train, years_train, X0_train, juveniles_train, adult_fems_train, T_ode_val, time_ode_val, years_val, X0_val, juveniles_val, adult_fems_val, params_opt)

% Input: - T_ode_train, T_ode_val (array): temperature time series for training and validation periods [°C]
%     - time_ode_train, time_ode_val (array): monthly time grids for training and validation periods [months]
%     - years_train, years_val (array): yearly observation timestamps for training and validation
%     - X0_train, X0_val (array): initial states [J0, A0] for each period [#crabs/1000m²]
%     - juveniles_train, juveniles_val (array): observed juvenile densities [#crabs/1000m²]
%     - adult_fems_train, adult_fems_val (array): observed adult female densities [#crabs/1000m²]
%     - params_opt (array): optimal parameter vector from calibration
% 
% Output: none (displays figures)
% 
% Generates 2 time-series plots (training and validation) comparing observed data against simulated trajectories with both nominal (theta_0) and optimal (theta_opt) parameters, for juveniles and adults separately."""

% initial parameters
params0 = pack_params([20,3,30.62/12, 0.01256, 0.9/12, 1, 1/15.7, 0.294/12]);
[~,X_sim_train0] = ode15s(@(t,X) crab_model_ode(X, params0, T_ode_train, time_ode_train, t), time_ode_train, X0_train);
[~,X_sim_val0] = ode15s(@(t,X) crab_model_ode(X, params0, T_ode_val, time_ode_val, t), time_ode_val, X0_val);

% optimum parameters
p_opt = pack_params(params_opt);
[~,X_sim_train] = ode15s(@(t,X) crab_model_ode(X, p_opt, T_ode_train, time_ode_train, t), time_ode_train, X0_train);
[~,X_sim_val] = ode15s(@(t,X) crab_model_ode(X, p_opt, T_ode_val, time_ode_val, t), time_ode_val, X0_val);

% plots

time_figure_train = [years_train(1):1/12:years_train(end)+1]';
time_figure_val = [years_val(1):1/12:years_val(end)+1]';


fig1 = figure(7);
fig1.WindowState = 'maximized';
hold on;
scatter(years_train, juveniles_train, 'b','filled','LineWidth',1.5);
plot(time_figure_train(1:end-1), X_sim_train(:,1), 'b-','LineWidth',1);
plot(time_figure_train(1:end-1), X_sim_train0(:,1), 'b--','LineWidth',1);
scatter(years_train, adult_fems_train, 'r','filled','LineWidth',1.5);
plot(time_figure_train(1:end-1), X_sim_train(:,2), 'r-','LineWidth',1);
plot(time_figure_train(1:end-1), X_sim_train0(:,2), 'r--','LineWidth',1);
fig1.CurrentAxes.XLim = [min(years_train)-0.5, max(years_train)+1.5];
legend1 = legend('J_{obs}','J_{sim}, \theta_{opt}', 'J_{sim}, \theta_0', 'A_{obs}','A_{sim}, \theta_{opt}', 'A_{sim}, \theta_0');
set(legend1,'Position',[0.85,0.28,0.142,0.42]);
xlabel('year');
ylabel('crabs/1000m^2');
grid on;
set(gca, 'Position',[0.08,0.125,0.75,0.8]);
title('Calibration');

fig2 = figure(8);
fig2.WindowState = 'maximized';
hold on;
scatter(years_val, juveniles_val, 'b','filled','LineWidth',1.5);
plot(time_figure_val(1:end-1), X_sim_val(:,1), 'b-','LineWidth',1);
plot(time_figure_val(1:end-1), X_sim_val0(:,1), 'b--','LineWidth',1);
scatter(years_val, adult_fems_val, 'r','filled','LineWidth',1.5);
plot(time_figure_val(1:end-1), X_sim_val(:,2), 'r-','LineWidth',1);
plot(time_figure_val(1:end-1), X_sim_val0(:,2), 'r--','LineWidth',1);
fig2.CurrentAxes.XLim = [min(years_val)-0.5, max(years_val)+1.5];
legend2 = legend('J_{obs}','J_{pred}, \theta_{opt}', 'J_{pred}, \theta_0', 'A_{obs}','A_{pred}, \theta_{opt}', 'A_{pred}, \theta_0');
set(legend2,'Position',[0.85,0.28,0.142,0.42]);
xlabel('year');
ylabel('crabs/1000m^2');
grid on;
set(gca, 'Position',[0.1,0.18,0.8,0.7]);
title('Test');
