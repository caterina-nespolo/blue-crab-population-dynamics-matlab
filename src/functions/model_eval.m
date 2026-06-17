function [Y, X_state] = model_eval(X, tspan, T, X0_state, J_obs, A_obs)
% Input: - X (array): population of parameter vectors to evaluate
%         - tspan (array): monthly time grid for ODE integration [months]
%         - T (array): temperature time series over tspan [°C]
%         - X0_state (list of float): initial state [J0; A0] [#crabs/1000m²]
%         - J_obs (array): observed juvenile densities [#crabs/1000m²]
%         - A_obs (array): observed adult female densities [#crabs/1000m²]
% 
% Output: - Y (array): MSE values [mse_J; mse_A] for each parameter set
%         - X_state (array): ODE solution of the last evaluated parameter set
% 
% Evaluates the model over a population of parameter vectors. Used in sensitivity analysis. 
% For each set, integrates the ODE, aggregates the solution to yearly values, and computes MSE against observations.

Y = zeros(size(X,1),2);
X_state = zeros(size(X,1),length(tspan),2);
    for k = 1:size(X,1)
        params = pack_params(X(k,:));
        options_ode15s = odeset(RelTol=1e-6,AbsTol=1e-6);
        [~,X_state] = ode15s(@(t,X_state) crab_model_ode(X_state, params, T, tspan, t), tspan, X0_state, options_ode15s);
        X_state_yearly = make_X_yearly(X_state,length(J_obs));
        mse = [mean((X_state_yearly(:,1) - J_obs).^2); ...
            mean((X_state_yearly(:,2) - A_obs).^2)]; % mean squared error
        Y(k,1) = mse(1);
        Y(k,2) = mse(2);
    end
end