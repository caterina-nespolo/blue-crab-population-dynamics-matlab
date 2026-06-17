function dXdt = crab_model_ode(X, params, T, tspan, t)

% Input: - t (float): current time point, provided by the ODE solver
%     - X (array of float): state vector [J; A] ,juveniles and adult females densities [#crabs/1000m²]
%     - params (struct): model parameter structure, as returned by pack_params
%     - T (array): temperature time series [°C], defined over tspan
%     - tspan (array): time grid corresponding to T [months]
% 
% Output: - dXdt (array): dXdt is a array of two floats [dJdt; dAdt]
% 
% ODE wrapper for numerical integration. Interpolates temperature at the current time t from the discrete series T, then calls crab_model to compute the state derivatives.
    u = interp1(tspan,T,t);
    dXdt = crab_model(X, params, u);
end