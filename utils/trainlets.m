function [A] = trainlets(params)
%TRAINLETS Summary of this function goes here
%   Detailed explanation goes here

addpath('OSDL/utilities/');

Ytrain = params.Y;
Tdata = params.k;
Tdict = params.s;

% Dictionary size
m = params.dict_size(1);
n = params.dict_size(2);

params = [];
Ytest = [];


%% Standard Wavelets base dictionary with tree arrangement
phi = eye(n, m); % zeros(n, m);
Aini = normc(full(HardThres(randn(n, m), Tdict)));
params.initA = sparse(Aini);
% disp('Start training ')

%% OSDL

params.BatchSize = 2e2;
params.Tdict = Tdict; % 40 for 16x16
params.Iter = 50;
params.mode = 'sparse';
params.Tdata = Tdata;
params.dictsep = phi; 
params.Ytrain = Ytrain;
params.Ytest = Ytest;
params.NCleanDict = 0; % pruning redundant atoms

[A, ~, ~, ~] = OSDL(params);
A = normc(A);


end

