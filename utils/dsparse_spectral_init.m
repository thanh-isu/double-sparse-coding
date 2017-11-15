%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a double-sparse spectral initilization for double-sparse coding that follows
% the idea and notations of Arora et al paper. For the estimate be sparse, we aplly a 
% hard thresholding on each estimated atom.
% 
% - Inputs: params (k, s, p1, p2 and training samples Y1 and Y2

% L is the number of column recovered stored in A0, those who are not
% recovered are replaced by zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [L, A0] = dsparse_spectral_init(params)

addpath('OSDL/utilities/')

Y = params.Y;
%
n = params.dict_size(1);
m = params.dict_size(2);
k = params.k; % Representation sparsity
s = params.s; % Dictionary sparsity

Y1 = params.Y1; % Sampling data sets for u and v
Y2 = params.Y2; % Fresh samples independent of u and v, for estimation

% Number of sampling and fresh samples
p1 = size(Y1, 2);
p = size(Y2, 2);

% Number of iteration
T = params.iterations;

% Running mode: thresholding after PCA or or truncation before SVD
mode = params.mode;

% The outcome dictionary
A0 = zeros(n, m);

% Keep track # of columns that have been just computed 
L = 0;

% Log
timer = tic;
num_iterations = 0;
while L < m && num_iterations < T
    % randomly pick u and v from Y1, fresh samples. Probaly keep track by
    % saving a random seed via rng()
    num_iterations = num_iterations + 1;
    freshsamples = Y1(:, randperm(p1, 2));
    u = freshsamples(:, 1);
    v = freshsamples(:, 2);
    
    reweight = (Y2'*u) .* (Y2'*v);
    
    if strcmp(mode, 'trunc')
        % Diagonal entries of the reduced covariance matrix
        e = 1/p*(Y2 .^ 2 * reweight);
        [e_sort, inds] = sort(abs(e), 'descend');
        
        % Check the diagonal to estimate support
        if e_sort(s) < 0.025 %|| e_sort(s+1)/e_sort(s) > 0.6 % 1 k/mr & r/log^2n
            continue;
        end
        % Estimate of column support of A
        support = sort(inds(1:2));
        Y_trunc = Y2(support, :);
        Muv = 1/p* (Y_trunc .* reweight')*Y_trunc';
    else
        Muv = 1/p* (Y2.* reweight') *Y2';
    end
    
    % Power method may be better here for very large n
    [~, D, V] = svd(Muv, 'econ');
    % msort = sort(abs(diag(Muv)), 'descend');
    d1 = D(1, 1); d2 = D(2, 2);
    % Check whether or not u and v share one element
    if d1 > 0.05 && d1/d2 > 2 % Good condition for synthetic data: 0.1 and 2
        if strcmp(mode, 'trunc')
            z = zeros(n, 1);
            z(support) = V(:, 1);
        else
            % Get the top pricipal component
            z = V(:, 1);
            if strcmp(params.mode, 'thres')
                % Hard-thresholding performed here to ensure the closeness with others
                z = HardThres(z, s);
            end
        end
        % Make sure that z has been not found before by checking
        % closness/incoherence
        if delta_closeness_check(A0(:, 1:L), z)
            L = L + 1;
            A0(:, L) = z;
        end
    end
end
running_time = toc(timer);
% disp(['Total running time ' num2str(running_time), ' and iterations' num2str(num_iterations)]);
A0 = normc(A0);

end
