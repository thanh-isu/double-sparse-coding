function [] = display_results(mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if mode == 1
    thres_dsc = load('Experiments/aaai/output/thres_dsc_noiseless_3.mat');
    trunc_dsc = load('Experiments/aaai/output/trunc_dsc_noiseless_3.mat');
    % Trainlets initalize with 0
    trainlet_dsc = load('Experiments/aaai/output/trainlets_dsc_noiseless_rd.mat');
    % Trainlets initialized with I
    trainlet_dscI = load('Experiments/aaai/output/trainlets_dsc_noiseless_I_3.mat');
    arora_dsc = load('Experiments/aaai/output/arora_dsc_noiseless_3.mat');
    varied_p = thres_dsc.varied_p;
else
    thres_dsc = load('Experiments/aaai/output/thres_noise.mat');
    trunc_dsc = load('Experiments/aaai/output/trunc_noise.mat');
    % Trainlets initalize with 0
    trainlet_dsc = load('Experiments/aaai/output/trainlets_noise_rd.mat');
    % Trainlets initialized with I
    trainlet_dscI = load('Experiments/aaai/output/trainlets_noise_rd.mat');
    arora_dsc = load('Experiments/aaai/output/arora_noise.mat');
    varied_p = thres_dsc.varied_p;
end


% Probability of success
prob_thres = thres_dsc.prob_success;
prob_trunc = trunc_dsc.prob_success;
prob_trlets1 = trainlet_dsc.prob_success;
prob_trlets2 = trainlet_dscI.prob_success;
prob_arora = arora_dsc.prob_success;
title = 'Probability of success';
result = [varied_p', prob_trunc, prob_arora, prob_thres, prob_trlets1];
save('Experiments/aaai/output/prob_success_nless.txt', 'result', '-ascii', '-double')
plot_curve(varied_p, prob_trunc, prob_thres, prob_arora, prob_trlets1, prob_trlets2, title);

% Error
error_thres = thres_dsc.mean_error;
error_trunc = trunc_dsc.mean_error;
error_trlets1 = trainlet_dsc.mean_error;
error_trlets2 = trainlet_dscI.mean_error;
error_arora = arora_dsc.mean_error;
title = 'Avg. eror over 100 runs';
result = [varied_p', error_trunc, error_arora, error_thres, error_trlets1];
save('Experiments/aaai/output/error_nless.txt', 'result', '-ascii', '-double')
plot_curve(varied_p, error_trunc, error_thres, error_arora, error_trlets1, error_trlets2, title);

% Probability of success
time_thres = thres_dsc.run_time;
time_trunc = trunc_dsc.run_time;
time_trlets1 = trainlet_dsc.run_time;
time_trlets2 = trainlet_dscI.run_time;
time_arora = arora_dsc.run_time;
title = 'Avg. running time over 100 runs';
result = [varied_p', time_trunc, time_arora, time_thres, time_trlets1];
save('Experiments/aaai/output/run_time_nless.txt', 'result', '-ascii', '-double')
plot_curve(varied_p, time_trunc, time_thres, time_arora, time_trlets1, time_trlets2, title);


end

function plot_curve(xAxis, methodA, methodB, methodC, methodD, methodE, title)
figure; plot(xAxis, methodA, '--rs', 'MarkerSize', 10);
hold on;
plot(xAxis, methodB, '--bd', 'MarkerSize', 10);
plot(xAxis, methodC, '--kv', 'MarkerSize', 10);
plot(xAxis, methodD, '--g^', 'MarkerSize', 10);
%plot(xAxis, methodE, '--go', 'MarkerSize', 10);

xlabel('Number of samples', 'FontSize', 12)
ylabel(title, 'FontSize', 12)
set(gca, 'FontSize', 15)
grid on; grid minor;
legend( 'Ours', 'Arora+HT', 'Arora', 'Trainlets1', 'Location', 'Best')

end