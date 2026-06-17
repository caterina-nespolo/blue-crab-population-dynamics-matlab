function [dXdt,F] = crab_model(X, params, T)
% 
% Input: - X (array): state vector [J; A], juveniles and adult females densities [#crabs/1000m²]
%     - params (struct): model parameter structure with keys alpha, b, p, k_max, x, m, r_T, beta_RR, f_l
%     - T (float): temperature at the current time step [°C]
% 
% Output: - dXdt (array): dXdt is a array [dJdt; dAdt] (floats)
% 
% Core ODE system for blue crab population dynamics. 
% Computes recruitment via a temperature-dependent Ricker model, juvenile predation via a type-II functional response, 
% juvenile maturation weighted by a temperature-dependent metabolic rate (resp_rate), linear fishing mortality, and adult mortality. 
% Saturation constraints are applied to ensure non-negativity of all fluxes.

    J = X(1);
    A = X(2); 

    % parameters 
    alpha   = params.alpha;   % aximum per capita reproduction rate [1/months]
    b       = params.b;       % density-dependent effect on reproduction [(1000m^2/#crabs)^2]
    p       = params.p;       % predator density [#crabs/(1000m^2)]
    k_max   = params.k_max;   % maximum feeding rate [1/month]
    x       = params.x;       % prey density at 0.5 k_max [#crabs/(1000m^2)]
    m       = params.m;       % adult mortality rate [1/months]
    r_T     = params.r_T;     % parametro per collegare recruitment a temperatura [1/°C]
    beta_RR = params.beta_RR; % maturation rate of juveniles to be multiplied by resp_rate [RR/months]
    f_l     = params.f_l;     % linear fishing mortality rate [1/months]

    a_T =  70.59;
    b_T = -5.244;
    c_T =  0.108;
    resp_rate = 1./(a_T+b_T*T+c_T*T.^2);

    % recruitment (ricker con dipendenza dalla temperatura)
    R = r_T*alpha.*A/(1+b.*(A.^2)).*T;

    % juveniles predation
    P = (p+A).*k_max.*(J.^2)./(x^2+J.^2);

    % growth
    G = beta_RR*resp_rate.*J;

    % fishing 
    F = f_l.*A;

    % adults mortality
    M = m*A;

    % juveniles saturation
    total_J = J + R;
    P = min(P, total_J);
    G = min(G, total_J - P);

    % adults saturation
    total_A = A + G;
    M = min(M, total_A);
    F = min(F, total_A - M);

    % ode
    dJdt = R - P - G;
    dAdt = G - M - F; 

    dXdt = [dJdt; dAdt];
end
