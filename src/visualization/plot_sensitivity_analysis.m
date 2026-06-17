function plot_sensitivity_analysis(SA_out)

% Input: - sensitivity_analysis_results (struct): output of run_sensitivity_analysis, containing mi, sigma, convergence indices, confidence bounds, labels, and threshold
% 
% Output: none (displays figures)
% 
% Generates 8 plots for the sensitivity analysis results: 
% mi-sigma scatter plots for juveniles and adults (with and without confidence intervals), 
% and convergence plots of mi over increasing sample sizes (with and without confidence intervals). 
% A vertical dashed red line marks the significance threshold at thresh*max(mi).
    
X_labels = {'p','x','\alpha','b','m','\beta_{RR}','r_T','f_l'};

% results without confidence intervals
% juveniles
fig(1) = figure();
s1 = subplot(121);
s1.OuterPosition = [0,0,0.5,1];
hold on;
EET_plot(SA_out.mi_J, SA_out.sigma_J, X_labels)  
plot([SA_out.thresh*max(SA_out.mi_J);SA_out.thresh*max(SA_out.mi_J)],[min(SA_out.sigma_J);max(SA_out.sigma_J)],'r--','LineWidth',1)
title('Juveniles')
% adults
s2 = subplot(122);
s2.OuterPosition = [0.5,0,0.5,1];
EET_plot(SA_out.mi_A, SA_out.sigma_A, X_labels)
plot([SA_out.thresh*max(SA_out.mi_A);SA_out.thresh*max(SA_out.mi_A)],[min(SA_out.sigma_A);max(SA_out.sigma_A)],'r--','LineWidth',1)
title('Adults')

% convergence without confidence intervals
% juveniles
fig(2) = figure();
s3 = subplot(211);
s3.OuterPosition = [0,0.5,0.9,0.5];
plot_convergence(SA_out.m_r_J,SA_out.rr*(SA_out.M+1),[],[],[],'model evaluations','\mu^*',X_labels)   
title('Juveniles')  
s3.XLim = [min(SA_out.rr*(SA_out.M+1)),max(SA_out.rr*(SA_out.M+1))];
% adults
s4 = subplot(212);
s4.OuterPosition = [0,0,0.9,0.5];
plot_convergence(SA_out.m_r_A,SA_out.rr*(SA_out.M+1),[],[],[],'model evaluations','\mu^*',X_labels) 
title('Adults')
s4.XLim = [min(SA_out.rr*(SA_out.M+1)),max(SA_out.rr*(SA_out.M+1))];

% plots with confidence intervals
% juveniles
fig(3) = figure();
s5 = subplot(121);
s5.OuterPosition = [0,0,0.5,1];
EET_plot(SA_out.mi_J,SA_out.sigma_J,X_labels,SA_out.mi_lb_J,SA_out.mi_ub_J,SA_out.sigma_lb_J,SA_out.sigma_ub_J)
plot([SA_out.thresh*max(SA_out.mi_J);SA_out.thresh*max(SA_out.mi_J)],[min(SA_out.sigma_lb_J);max(SA_out.sigma_ub_J)],'r--','LineWidth',1)
title('Juveniles')
% adults
s6 = subplot(122);
s6.OuterPosition = [0.5,0,0.5,1];
EET_plot(SA_out.mi_A,SA_out.sigma_A,X_labels,SA_out.mi_lb_A,SA_out.mi_ub_A,SA_out.sigma_lb_A,SA_out.sigma_ub_A)   
plot([SA_out.thresh*max(SA_out.mi_A);SA_out.thresh*max(SA_out.mi_A)],[min(SA_out.sigma_lb_A);max(SA_out.sigma_ub_A)],'r--','LineWidth',1)
title('Adults')

% convergenvce with confidence intervals
% juveniles
fig(4) = figure();
s7 = subplot(211);
s7.OuterPosition = [0,0.5,0.9,0.5];
plot_convergence(SA_out.m_r_J,SA_out.rr*(SA_out.M+1),SA_out.m_lb_r_J,SA_out.m_ub_r_J,[],'model evaluations','\mu^*',X_labels) 
s7.XLim = [min(SA_out.rr*(SA_out.M+1)),max(SA_out.rr*(SA_out.M+1))];
title('Juveniles')
s8 = subplot(212);
s8.OuterPosition = [0,0,0.9,0.5];
plot_convergence(SA_out.m_r_A,SA_out.rr*(SA_out.M+1),SA_out.m_lb_r_A,SA_out.m_ub_r_A,[],'model evaluations','\mu^*',X_labels)
title('Adults')
s8.XLim = [min(SA_out.rr*(SA_out.M+1)),max(SA_out.rr*(SA_out.M+1))];

end