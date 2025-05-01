function [is_fault, excluded_idx] = raim_detection(A, omc, weight, settings)
% RAIM
% Input:
%   A       - Geometric matrix
%   omc     - obs - predicted
%   weight  - Weighting (diagonal of C)
% Outputs:
%   is_fault      -  (true/false)
%   excluded_idx  - satellite id that requires exclusion

    
    W = diag(weight);
    %W = diag(ones(size(A,1),1))/(settings.sigma^2);
    



    residuals = omc;
    T = residuals' * W * residuals;
    sigma = settings.sigma;
    T_threshold = 5.33 * sigma;

    if T > T_threshold
        min_T = inf;
        excluded_idx = 0;
        for i = 1:size(A, 1)
            % exclude i-th satellite
            A_excluded = A; A_excluded(i, :) = [];
            W_excluded = W; W_excluded(i, :) = []; W_excluded(:, i) = [];
            omc_excluded = omc; omc_excluded(i) = [];
            
            % Check matrix rank and regularize
            H_excluded = A_excluded' * W_excluded * A_excluded;
            if rank(H_excluded) < 4
                continue;  % Skip geometrically ill-conditioned satellite exclusion
            end
            x_excluded = (H_excluded + 1e-8 * eye(4)) \ (A_excluded' * W_excluded * omc_excluded);
            
            % Compute residuals and test statistics
            residuals_excluded = omc_excluded - A_excluded * x_excluded;
            T_i = residuals_excluded' * W_excluded * residuals_excluded;
            
            if T_i < min_T
                min_T = T_i;
                excluded_idx = i;
            end
        end
        is_fault = (excluded_idx > 0);  % Mark fault only if valid fix is ​​found
    else
        is_fault = false;
        excluded_idx = 0;
    end
end