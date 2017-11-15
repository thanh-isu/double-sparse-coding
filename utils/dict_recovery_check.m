function [rec, A] = dict_recovery_check(Atrue, A0)
% The initial estimate A0 is certainly not match with the ground truth
% Atrue in term of sign and permutation. This function is to match their
% columnwise order and sign by bi-partite matching. 

% By constructing the bipartite graph (A,B) in which each node in A corresponds
% to one column of Atrue and each node in B corresponds to that of A0. Weight is 
% computed as cosine between any pair of columns. Maximumn weight bipartite matching
% gives us the maximum weight and the match. Based on that, we know whether
% or not the dictionary is recovered (in terms of sign and permutation).

% The outcome dictionary 
A = zeros(size(Atrue));

% Build the bipartite graph with Gram matrix: (cosine measure)
G = Atrue'*A0; % Atrue's columns correponds to the left part of bipartite

% Perfom matching
[val, mi, mj] = bipartite_matching(abs(G));

% Recover sign from matchings mj (permutation)
sign_Atrue = sign(Atrue);
A(:, mi) = abs(A0(:, mj)) .* sign_Atrue(:, mi);

rec = mi; % size(mi) < dim ==> not recovered

end
