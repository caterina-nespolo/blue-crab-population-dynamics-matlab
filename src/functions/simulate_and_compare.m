function mse = simulate_and_compare(params, tspan, X0, J_obs, A_obs, T)

% Input: - params (struct): model parameter dictionary, as returned by pack_params
%     - tspan (array): monthly time grid for ODE integration [months]
%     - X0 (list of float, len 2): initial state [J0, A0] [#crabs/1000m²]
%     - J_obs (array): observed juvenile densities [#crabs/1000m²]
%     - A_obs (array): observed adult female densities [#crabs/1000m²]
%     - T (array): temperature time series over tspan [°C]
% 
% Output: - mse (array): [mse_J; mse_A], mean squared errors on juveniles and adults
% 
% Objective function for calibration. 
% Integrates the ODE model with the given parameters, aggregates the solution to yearly values, and returns the MSE on both state variables against observations.
    
    [~,X] = ode15s(@(t,X) crab_model_ode(X, pack_params(params), T, tspan, t), tspan, X0);
    X_state_yearly = make_X_yearly(X,length(J_obs));
    mse = [mean((X_state_yearly(:,1) - J_obs).^2); ...
         mean((X_state_yearly(:,2) - A_obs).^2)]; % mean squared errors
end