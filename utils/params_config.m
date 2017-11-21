function [params] = params_config(params)
%PARAMS_CONFIG Different parameter for different baselines

if params.overcomplete == 0
    params.k = 6; % Sparsity of x
    params.s = 2; % Sparsity of A
    if params.reg == 1 % Noise regime
        params.reconst_err_thres = 0.5;
        if strcmp(params.mode, 'trunc')
            % thesholds for support estimate, expectedly O(k/mr) &
            % e2/e1 is not O^*(r/log^2n)
            params.e1 = 0.025;
            params.e2_over_e1 = 0.75;
            % 1st and 2nd singular values, sig1 and sig2. Expectedly, O(k/m)
            % and O^*(k/mlogn)
            params.sig1 = 0.03;
            params.sig1_over_sig2 = 3;
        else % strcmp(params.mode, 'thres') || strcmp(params.mode, 'arora')
            % 1st and 2nd singular values, sig1 and sig2
            params.sig1 = 0.05;
            params.sig1_over_sig2 = 2;
        end
    else
        params.reconst_err_thres = 1e-4;
        if strcmp(params.mode, 'trunc')
            params.e1 = 0.03;
            params.e2_over_e1 = 0.75;
            params.sig1 = 0.05;
            params.sig1_over_sig2 = 3;
        else
            params.sig1 = 0.07;
            params.sig1_over_sig2 = 2;
        end
    end
else
    params.k = 10; % Sparsity of x
    params.s = 6; % Sparsity of A
    if params.reg == 1
        params.reconst_err_thres = 0.1;
        if strcmp(params.mode, 'trunc') 
            params.e1 = 0.025;
            params.e2_over_e1 = 0.75;
            params.sig1 = 0.03;
            params.sig1_over_sig2 = 3;
        else
            params.sig1 = 0.05;
            params.sig1_over_sig2 = 2;
        end
    else
        params.reconst_err_thres = 10;
        if strcmp(params.mode, 'trunc')
            params.e1 = 0.03;
            params.e2_over_e1 = 0.75;
            params.sig1 = 0.05;
            params.sig1_over_sig2 = 3;
        else
            params.sig1 = 0.07;
            params.sig1_over_sig2 = 2;
        end
    end
end


end

