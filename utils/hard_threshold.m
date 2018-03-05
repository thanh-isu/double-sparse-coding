function [X] = hard_threshold(X, k)
%HARD_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here

% Column-wise hard thresholding operator. Keep k largest entries and zero
% out the rest

% sort each column
[~, inds] = sort(abs(X), 1, 'descend');

[~, ncols] = size(X); % matrix multiplication may be better
for i = 1:ncols
    X(inds(k+1:end, i), i) = 0;
end

end

