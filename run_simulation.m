function [] = run_simulation()
% 
% Running mode: mode 'trunc', 'arora', 'thres', 'trainlets'

% Load the data (Ar, Ytrain, Xt) and change the parameter accordingly
load data/2_no_noise.mat
params.reg = 0; % reg for noise/noiseless regime
params.overcomplete = 1; % 1 - complete data, 2 - overcomplete

% Run the experiment varying p, 10 values
p = size(Ytrain, 2);
varied_p = (2:10)*5e2;
numb_p = size(varied_p, 2);

% Number of trials for each p
num_mcmc = 100;

prob_success = zeros(numb_p, 1);
mean_error = zeros(numb_p, 1);
detailed_error = zeros(numb_p, num_mcmc);
run_time = zeros(numb_p, 1);

% Set parameters for initialization procedure
params.dict_size = size(Ar);
params.iterations = 2e3; % Number of iterations of the algorithm
% 'trunc', 'thres', 'trainlets' and 'arora' mode normal SC initialization with IHT
params.mode = 'arora';

% Load params
params = params_config(params);

fname = sprintf('output/%s_dsc_noiseless_oc.mat', params.mode);

for i = 1:numb_p
    % Fix number of samples, shuffle the data set and get pi of them
    pi = varied_p(i);
    Y = Ytrain(:, randperm(p, pi)); %randperm(p, pi) 1:pi
    params.Y = Y;
    
    % Storing variables
    success_count = 0;
    error = 0;
    per_trial_time = 0;
    for t = 1:num_mcmc
        % Partition data for the sampling in spectral initialization
        [params.Y1, params.Y2] = data_partition(params);
        timer = tic;
        if strcmp(params.mode, 'trainlets')
            A = trainlets(params);
        else
            [numb_atom_rec, A0] = spectral_init_algorithm(params);

            % Given the initial to the main algorithm
            params.A0 = A0;
            A = descent_algorithm(params);
        end
        
        % Running time is measure right after learning
        per_trial_time = per_trial_time + toc(timer);
        
        % Check the success
        [match, A] = dict_recovery_check(Ar, A);
        per_trial_error = norm(A - Ar, 'fro');
        
        if size(match, 1) == size(Ar, 1) && per_trial_error < params.reconst_err_thres ...
%                 && numb_atom_rec == size(Ar, 2)
            success_count = success_count + 1;
        end
        
        % record the results
        error = error + per_trial_error;
        detailed_error(i, t) = per_trial_error;
        
        % figure; imagesc(A);
        if rem(t, 50) == 0
            fprintf('%d th simulation and %d runs \n', i, t);
        end
    end
    
    % summarize and save the results
    prob_success(i) = success_count/num_mcmc;
    mean_error(i) = error/num_mcmc;
    run_time(i) = per_trial_time/num_mcmc;
end

save(fname, 'varied_p', 'prob_success', 'mean_error', 'run_time', 'detailed_error');
% txt files with ascii for tikz plots
save(sprintf('output/time_noiseless_%s_oc.txt', params.mode), 'run_time', '-ascii', '-double'); 
save(sprintf('output/psucc_noiseless_%s_oc.txt', params.mode), 'prob_success', '-ascii', '-double');
save(sprintf('output/error_noiseless_%s_oc.txt', params.mode), 'mean_error', '-ascii', '-double');

end

