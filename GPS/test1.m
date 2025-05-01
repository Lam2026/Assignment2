%
gt = [22.328444770087565; 114.1713630049711];

[error_lat,error_lon] = latlon_to_meters(22.328444770087565, 114.1713630049711, navSolutions.latitude, navSolutions.longitude);

error_height = navSolutions.height - 3;

sigma = 3;          
P_fa = 1e-2;       
P_md = 1e-7;      
AL = 50;           
n_sat = 5;          
num_samples = 39;

PL_3D = 29.63;
fprintf('3D Protection Level: %.2f meters\n', PL_3D);


rng(0); 
VPE = error_lat'; 
VPL = PL_3D*ones(num_samples,1); 


x_edges = linspace(0, 60, 50);
y_edges = linspace(0, 60, 50);
[N, ~, ~] = histcounts2(VPE, VPL, x_edges, y_edges);


figure;
h = pcolor(x_edges(1:end-1), y_edges(1:end-1), log10(N' + 1)); 
set(h, 'EdgeColor', 'none');
colormap(parula); 
colorbar;
hold on;


plot(xlim, [AL AL], 'r--', 'LineWidth', 2, 'DisplayName', sprintf('AL=%.1fm', AL));


plot([0 max(xlim)], [0 max(ylim)], 'r --', 'LineWidth', 1.5, 'DisplayName', 'VPE = VPL');

plot([AL AL], ylim, 'r--', 'LineWidth', 2, 'DisplayName', sprintf('AL=%.1fm', PL_3D));

% fill([min(xlim) max(xlim) max(xlim) min(xlim)], ...
%      [0 0 AL AL], 'g', 'FaceAlpha', 0.5, 'EdgeColor', 'none', ...
%      'DisplayName', 'Safe Zone (VPL < AL)');

% fill([min(xlim) max(xlim) max(xlim) min(xlim)], ...
%      [AL AL max(ylim) max(ylim)], 'r', 'FaceAlpha', 0.8, 'EdgeColor', 'none', ...
%      'DisplayName', 'Hazard Zone (VPL > AL)');
% 
% fill([min(xlim) max(xlim) max(xlim) min(xlim)], ...
%      [AL AL max(xlim) max(xlim)], 'r', 'FaceAlpha', 0.8, 'EdgeColor', 'none', ...
%      'DisplayName', 'Hazard Zone (VPL > AL)');



xlabel('Vertical Position Error (VPE) [m]');
ylabel('Vertical Protection Level (VPL) [m]');
title(sprintf('Stanford Chart Analysis\nn=%d satellites, σ=%.1fm, AL=%.1fm', n_sat, sigma, AL));
legend('Location', 'northeast');
grid on;

text(0.05*max(xlim), 0.9*max(ylim), ...
     sprintf('P_{fa}=%.0e\nP_{md}=%.0e', P_fa, P_md), ...
     'BackgroundColor', 'white', 'FontSize', 10);


xlim([0 max(x_edges)]);
ylim([0 max(y_edges)]);


load('skymask_A1_urban.csv');
azimuth = skymask_A1_urban(:,1);
elevation = skymask_A1_urban(:,2);


figure;
polarplot(deg2rad(azimuth), 90 - elevation, 'b-', 'LineWidth', 1.5);
hold on;
                           
az0 = [57.373079481041
          139.846297612608
           21.819680619507
          41.5608139864159
          207.180891799642
          116.020031622361];

el0 = [73.8389672888709
          22.3163665202597
          59.8762379792772
          46.8764477490953
          59.9415398414719
          28.4027161879816];


theta = deg2rad(az0);      
r = [90;90;90;90;90;90] - el0;            


ssl = polarplot(theta(1), r(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);
ssn = polarplot(theta(2), r(2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
polarplot(theta(3), r(3), 'go', 'MarkerSize', 10, 'LineWidth', 2);
polarplot(theta(4), r(4), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
polarplot(theta(5), r(5), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
polarplot(theta(6), r(6), 'ro', 'MarkerSize', 10, 'LineWidth', 2);


title('SkyMask');
rlim([0 90]);              
set(gca, 'ThetaDir', 'clockwise');      
set(gca, 'ThetaZeroLocation', 'top'); 
ax = gca;
ax.RAxis.Label.String = 'Zenith Angle (90 - EL)';
legend([ssn, ssl], {'LOS', 'NLOS'}, 'Location', 'best');set(gca, 'ThetaDir', 'clockwise'); 

function [PL_3D, HPL, VPL] = dynamic_PL(n_sat, sigma, P_fa, P_md, A, W)
    dof = n_sat - 4;
    
    T_thresh = chi2inv(1-P_fa, dof) * sigma^2;
    fun = @(PL) ncx2cdf(T_thresh, dof, (PL^2)/sigma^2) - (1 - P_md);
    PL_3D = fzero(fun, 50);
    
    S = inv(A'*W*A);
    K_H = 5.33;     
    K_V = 5.33;     
    
    HPL = K_H * sqrt(max(S(1,1), S(2,2)));
    VPL = K_V * sqrt(S(3,3));
end

function PL = calculate_3D_PL(n_sat, sigma, P_fa, P_md)
    dof = n_sat - 4; 
    T_threshold = chi2inv(1 - P_fa, dof) * sigma^2;
    
    fun = @(PL) ncx2cdf(T_threshold, dof, (PL^2)/sigma^2) - (1 - P_md);
    PL_guess = 50; 
    options = optimset('Display','off');
    PL = fzero(fun, PL_guess, options);
end

function [distance_lat,distance_lon] = latlon_to_meters(latGT, lonGT, lat, lon)
    R = 6371000;  
    
    latitude_diff = lat - latGT;
    longitude_diff = lon - lonGT;
    
    distance_lat = latitude_diff * (pi / 180) * R; 
    distance_lon = longitude_diff * (pi / 180) * R * cosd(latGT); 
    
end