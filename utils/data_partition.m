function [Y1, Y2] = data_partition(params)
%DATA_PARTITION Partition the whole sample set params.Y into P1 and P2. P1
%with samples Y1 for sampling u and v. The other is for estimation. The
%size of P1 and P2 is pre-specified but depends on some required orders of
%the algorithm

Y = params.Y;
n = params.dict_size(1);
m = params.dict_size(2);

% Total number of samples
p = size(Y, 2);

% Devide training set into 2 sets P1 and P2
p1 = round(max(0.1*p, m*log(n))); % O(mlogm) is limit

% Randomly pick p1 samples from Y
P1 = randperm(p, p1);

% The rest is for fresh samples
P2 = 1:p; P2(P1) = [];

Y1 = Y(:, P1); Y2 = Y(:, P2);

% Get all
Y1 = Y; Y2 = Y;
end

