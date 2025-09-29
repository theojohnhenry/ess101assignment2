clc, clear, clf
load("output.mat"), load("input.mat");

% 75/25 split of training data and validation
N = length(y);

N_est = 2000; %variable parameter for split
N_val = length(y) - N_est ;

u_est = u(1:N_est); y_est = y(1:N_est);
u_val = u(N_est+1:N); y_val = y(N_est+1:N);

span_est = linspace(1,N_est,N_est); %1-3000
span_val = linspace(N_est+1,N,N_val); %3001-4000

scatter(span_est,y_est); %est data in blue
hold on
scatter(span_val, y_val); %val data in orange
hold on

% phi3 = [y_est(2); y_est(1); u_est(3)] % 
% phi4 = [y_est(3); y_est(2); u_est(4)] % 

PHI_eval = [y_est(2:N_est-1), y_est(1:N_est-2), u_est(3:N_est)];
y_eval_target = y_est(3:N_est); 

thetahat = (PHI_eval' * PHI_eval) \ (PHI_eval' * y_eval_target)

%% 1-step pred. RMSE 1.4578

PHI_Val = [y_val(2:N_val-1),y_val(1:N_val-2),u_val(3:N_val)];
y_val_target = y_val(3:end);
y_val_pred = PHI_Val * thetahat;

rmse_pred_a = sqrt(mean((y_val_target - y_val_pred).^2))

%% sim pred rmse

y_sim = zeros(N_val, 1);

y_sim(1) = y_val(1);
y_sim(2) = y_val(2);

for t = 3:N_val
    y_sim(t) = ...
    +thetahat(1)*y_sim(t-1) ...
    +thetahat(2)*y_sim(t-2) ...
    +thetahat(3)*u_val(t);
end

% Calculate the RMSE for the simulated predictions
rmse_sim_a = sqrt(mean((y_val(3:end) - y_sim(3:end)).^2))
