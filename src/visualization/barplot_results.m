function barplot_results(T_ode_train, time_ode_train, years_train, X0_train, juveniles_train, adult_fems_train, T_ode_val, time_ode_val, years_val, X0_val, juveniles_val, adult_fems_val, params_opt)

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
% Generates 4 grouped bar charts (juveniles and adults, for training and validation) comparing, year by year, the simulated values with nominal parameters, the observed data, and the simulated values with optimal parameters.

% initial parameters
params0 = pack_params([20,3,30.62/12, 0.01256, 0.9/12, 1, 1/15.7, 0.294/12]);
[~,X_sim_train0] = ode15s(@(t,X) crab_model_ode(X, params0, T_ode_train, time_ode_train, t), time_ode_train, X0_train);
[~,X_sim_val0] = ode15s(@(t,X) crab_model_ode(X, params0, T_ode_val, time_ode_val, t), time_ode_val, X0_val);

% optimum parameters
p_opt = pack_params(params_opt);
[~,X_sim_train] = ode15s(@(t,X) crab_model_ode(X, p_opt, T_ode_train, time_ode_train, t), time_ode_train, X0_train);
[~,X_sim_val] = ode15s(@(t,X) crab_model_ode(X, p_opt, T_ode_val, time_ode_val, t), time_ode_val, X0_val);


% colors
c1 = "#0072BD";
c2 = "#EDB120";  
c3 = "#D95319"; 

% barplots

% training
X_figure_train = X_sim_train(1:12:end,:);
X_figure_train0 = X_sim_train0(1:12:end,:);

fig = figure(9);
hold on;
s1 = subplot(211);
hold on;
% juveniles train
b1 = bar([years_train,years_train,years_train],...
    [X_figure_train0(:,1),juveniles_train,X_figure_train(:,1)]);
b1(1).FaceColor = c1;
b1(2).FaceColor = c2;
b1(3).FaceColor = c3;
b1(1).EdgeColor = c1;
b1(2).EdgeColor = c2;
b1(3).EdgeColor = c3;
s1.Box = 'off';
errorbar(years_train,juveniles_train,0.2*juveniles_train,'|','CapSize',10,'Color','black','LineWidth',1);
legend('\theta_{0}','data','\theta_{opt}');
grid on;
title('Juveniles calibration');
s1.Position=[0.08,0.62,0.8,0.3];
s2 = subplot(2,1,2);
hold on;
% adults train
b2 = bar([years_train,years_train,years_train],...
    [X_figure_train0(:,2),adult_fems_train,X_figure_train(:,2)]);
b2(1).FaceColor = c1;
b2(2).FaceColor = c2;
b2(3).FaceColor = c3;
b2(1).EdgeColor = c1;
b2(2).EdgeColor = c2;
b2(3).EdgeColor = c3;
s2.Box = 'off';
errorbar(years_train,adult_fems_train,0.2*adult_fems_train,'|','CapSize',10,'Color','black','LineWidth',1);
legend('\theta_{0}','data','\theta_{opt}');
grid on;
title('Adults calibration');
s2.Position=[0.08,0.125,0.8,0.3];

% testing
X_figure_val = X_sim_val(1:12:end,:);
X_figure_val0 = X_sim_val0(1:12:end,:);

fig = figure(10);
s3 = subplot(211);
hold on;
% juveniles test
b3 = bar([years_val,years_val,years_val],...
    [X_figure_val0(:,1),juveniles_val,X_figure_val(:,1)]);
b3(1).FaceColor = c1;
b3(2).FaceColor = c2;
b3(3).FaceColor = c3;
b3(1).EdgeColor = c1;
b3(2).EdgeColor = c2;
b3(3).EdgeColor = c3;
s3.Box = 'off';
errorbar(years_val,juveniles_val,0.2*juveniles_val,'|','CapSize',10,'Color','black','LineWidth',1);
legend('\theta_{0}','data','\theta_{opt}');
grid on;
title('Juveniles testing');
s3.Position=[0.08,0.62,0.8,0.3];
s4 = subplot(2,1,2);
hold on;
% adults train
b4 = bar([years_val,years_val,years_val],...
    [X_figure_val0(:,2),adult_fems_val,X_figure_val(:,2)]);
b4(1).FaceColor = c1;
b4(2).FaceColor = c2;
b4(3).FaceColor = c3;
b4(1).EdgeColor = c1;
b4(2).EdgeColor = c2;
b4(3).EdgeColor = c3;
s4.Box = 'off';
errorbar(years_val,adult_fems_val,0.2*adult_fems_val,'|','CapSize',10,'Color','black','LineWidth',1);
legend('\theta_{0}','data','\theta_{opt}');
grid on;
title('Adults testing');
s4.Position=[0.08,0.125,0.8,0.3];