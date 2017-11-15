function [A] = neural_sparse_coding(params)
%NEURAL_SPARSE_CODING Summary of this function goes here
%   Detailed explanation goes here

addpath('OSDL/utilities/')

A0 = params.A0;
[~, m] = size(A0);

% Number of samples
Y = params.Y;
p = size(Y, 2);

% Dictionary and sparse code
A = A0;
X = zeros(m, p);

% Sparsity parameters
k = params.k;
s = params.s;

% Number of iterations
T = 20;
% Maximum coefficients
C = 1;

% Alternating algorithm with learning rate
eta = m/k; % at leat Omega(k/k)

for i = 1:T
    % Simple thresholding encoding rule
    X = A'*Y;
    X = X .* (abs(X) >= C/2);
    
    % Noisy gradient
    Y_hat = A*X;
    residual = Y - Y_hat;
    norm(residual, 'fro');
    
    % Update the dictionary with noisy gradient
    g = 1/p*residual*sign(X)';
    A = A + eta*g;
    if ~strcmp(params.mode, 'arora')
    	A = HardThres(A, s);
    end
    A = normc(full(A));
end

end