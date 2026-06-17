function X_figure = make_X_yearly(X,n)

% Input: - X (array): monthly ODE solution with rows [J; A]
%     - n (int): number of yearly observations to return
% 
% Output: - X_yearly (array): yearly aggregated values for juveniles and adults
% 
% Converts the monthly ODE solution into yearly values comparable with observed data, which are collected between December and March. 
% The first year is the mean of the first 3 months; subsequent years are the mean of the December–March window of each year.
    
X_figure = zeros(n,2);
X_figure(1,:) = mean([X(1,:);X(2,:);X(3,:)],1);
temp1 = [X(12:12:end-1,1),X(13:12:end,1),X(14:12:end,1),X(15:12:end,1)];
temp2 = [X(12:12:end-1,2),X(13:12:end,2),X(14:12:end,2),X(15:12:end,2)];
X_figure(2:end,1) = mean(temp1,2);
X_figure(2:end,2) = mean(temp2,2);
end
