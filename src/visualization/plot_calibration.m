function plot_calibration(cal_out)

% Input: - cal_out (struct): output of run_calibration, containing the Pareto front, optimal solution, initial cost, bounds, and selected parameter indices
% 
% Output: none (displays figures)
% 
% Generates 2 plots: the Pareto front in the (mse_J, mse_A) space with markers for the nominal parameters theta_0 and the optimal solution theta_opt
% and a dot-and-interval plot showing, for each calibrated parameter, its optimal value within its calibration bounds.


% pareto front
pareto_figure = figure(5);
hold on
scatter(cal_out.pareto_front(:,1), cal_out.pareto_front(:,2),'filled','MarkerFaceColor',"#EDB120");
scatter(cal_out.cost0(1), cal_out.cost0(2),'b','*','LineWidth',1.5);
scatter(cal_out.opt_cost(1), cal_out.opt_cost(2),'r','*','LineWidth',1.5);
grid on;
legend('Pareto front','\theta_0','\theta_{opt}');
xlabel('MSE_J');
ylabel('MSE_A');
title('Pareto front');

% parameters intervals
params_labels = {'p'; 'x'; '\alpha'; 'b'; 'm'; '\beta_{RR}'; 'r_T'; 'f_l'};
colors = ["#0072BD", "#D95319", "#EDB120", "#80B3FF", "#BD0048"];
j = 1;
lgnd = [];
fig = figure(6);
hold on;
for i = cal_out.selected_parameters_indices
    c = colors(j);
    j = j + 1;
    scatter(cal_out.params_opt(i), -j, 'filled','MarkerFaceColor',c);
    lgnd = [lgnd ; params_labels(i)];
end
k = 1;
for i = cal_out.selected_parameters_indices
    c = colors(k);
    k = k + 1;
    plot([cal_out.lb(i), cal_out.ub(i)], [-k, -k], 'Color',c);
end
fig.CurrentAxes.YLim = [-j-0.5,-0.5];
grid on;
legend(lgnd);
