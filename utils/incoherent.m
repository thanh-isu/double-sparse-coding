function [incoherent] = incoherent(A)
%INCOHERENT Summary of this function goes here
%   Detailed explanation goes here

% Compute Gram matrix of A to determine coherene
G = A' * A;
n = size(G);
tmp = abs(eye(n) - G);
incoherent = max(tmp(:));

end

