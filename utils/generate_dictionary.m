function [D] = generate_dictionary(n, m, r)
%GEN_TREE_BASED_DICTIONARY Generate random, overcomplete dictionary
% 
% INPUT: - dictionary size (n, m)
%        - sparsity r
% OUPUT: D - dictionary

% D - dictionary to be generated
D = zeros(n, m);
for j = 1 : m
    support = randperm(n, r);
    % Generate s-sparse atom, with Rademacher distribution
    d = zeros(n, 1); d(support) = randsample([-1, 1], r, true); %randn(sparsity, 1);
    D(:, j) = d;
end
D = normc(D);

end

