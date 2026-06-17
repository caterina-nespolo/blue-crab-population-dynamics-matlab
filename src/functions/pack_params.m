function paramStruct = pack_params(params)

% Input: - params (list of float, len 8): parameter vector [p, x, alpha, b, m, beta_RR, r_T, f_l]
% 
% Output: - paramStruct (struct): parameter structure with keys p, x, k_max, alpha, b, m, beta_RR, r_T, f_l
% 
% Builds the model parameter dictionary from a flat numeric vector. 
% Derives k_max (maximum feeding rate [1/month]) analytically from p and x. 
% The output is the format expected by crab_model

p = params(1);
x = params(2);
paramStruct = struct('p', p,... predator density [#crabs/(1000m^2)]
            'x', x,... prey density at 0.5 k_max [#crabs/(1000m^2)]
            'k_max', 34.5/log(x^2+52900/(x)^2)/12,... maximum feeding rate [1/months]
            'alpha', params(3),... aximum per capita reproduction rate [1/months]
            'b', params(4),... density-dependent effect on reproduction [(1000m^2/#crabs)^2]
            'm', params(5),... adult mortality rate [1/months]
            'beta_RR', params(6),...  maturation rate of juveniles to be multiplied by resp_rate [RR/months]
            'r_T', params(7),... %  parametro per collegare recruitment a temperatura [1/°C]
            'f_l', params(8)); % linear fishing mortality rate [1/months]
end

