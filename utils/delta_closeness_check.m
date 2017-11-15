function close = delta_closeness_check(A, z)
%%% Check whether or not new estimate z is close to any of the already
%%% estimated columns in A even after sign flip
%   
%   Input: A-matrix of already estimated atoms and a new estimate z
%   Output: True/False

close = false;
[~, m] = size(A);
if m==0 % The first atom is automatically added
    close = true;
    return;
end

delta = 1; % 1/log2(n)^c 
Z = repmat(z, [1 m]);
% Column-wise squared norms
coldiff = sum((Z-A) .^2, 1);
% The different affer sign flip
coldiff_signflip = sum((Z+A) .^2, 1);
if sqrt(min(coldiff)) > delta && sqrt(min(coldiff_signflip)) > delta
    close = true; 
end

end

