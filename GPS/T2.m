%% Input Data

% Ground‐truth position
lat0 = 22.3198722;  
lon0 = 114.209101777778;  
alt0 = 3.0;          
filePath = 'C:\Users\owner\Documents\MATLAB\GPS\navSolutions_urban.mat';

navSolutions1 = load(filePath);  
SkyMask.pr = navSolutions1.navSolutions.correctedP;
SkyMask.az = navSolutions1.navSolutions.az;
SkyMask.el = navSolutions1.navSolutions.el;
SkyMask.pos = navSolutions1.navSolutions.satllitePosition;

% Load SkyMask data
M = readmatrix('C:\Users\owner\Documents\MATLAB\GPS\SkyMask_A1_urban.csv');
SkyMask.SkyMaskAz = M(:,1);
SkyMask.SkyMaskEl = M(:,2);
SkyMaskElVec = nan(361,1);
for i = 1:numel(SkyMask.SkyMaskAz)
    a = round(mod(SkyMask.SkyMaskAz(i),360));
    SkyMaskElVec(a+1) = SkyMask.SkyMaskEl(i);
end
idx = find(~isnan(SkyMaskElVec));
SkyMask.SkyMaskElVec = interp1(idx-1, SkyMaskElVec(idx), (0:360)','linear','extrap');
figure;
hold on;
polarplot(deg2rad(SkyMask.SkyMaskAz), 90 - SkyMask.SkyMaskElVec, 'b-', 'LineWidth', 1.5);
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
hold off;

delta = 25;  
SkyMaskRel = max(0, SkyMask.SkyMaskElVec - delta);

% WGS-84
SkyMask.wgs = wgs84Ellipsoid('meters');
[x0,y0,z0] = geodetic2ecef(SkyMask.wgs,lat0,lon0,alt0);
dt0 = 0;  
c   = 299792458;  

[nSat, nEpoch] = size(SkyMask.pr);   
sol = nan(nEpoch,4);   
nVis  = zeros(nEpoch,1);

%% LOOP OVER EPOCHS
for k = 1:nEpoch
    SkyMask.rho_k = SkyMask.pr(:,k);       
    SkyMask.az_k  = SkyMask.az(:,k);       
    SkyMask.el_k  = SkyMask.el(:,k);       
    SkyMask.Psat  = transpose(squeeze(SkyMask.pos{k}));

    % SkyMask visibility & weights
    vis = false(nSat,1);
    w   = zeros(nSat,1);
    for i = 1:nSat
        a = mod(SkyMask.az_k(i),360);
        ai = floor(a)+1; 
        el_block = SkyMaskRel(ai);
        if SkyMask.el_k(i) > el_block
            w(i) = sin(deg2rad(SkyMask.el_k(i) - el_block)) * sin(deg2rad(SkyMask.el_k(i)));
            vis(i) = true;
        end
    end

    idx = find(vis);
    nVis(k) = numel(idx);
    fprintf('Visible satellites at epoch %d: %d\n', k, nVis(k));

    if numel(idx) < 4
        continue;  % cannot solve
    end

    % WLS via Gauss–Newton
    x_est = [x0; y0; z0; dt0];
    tol   = 1e-4;    
    for iter = 1:10
        m = numel(idx);
        SkyMask.H = zeros(m,4);
        SkyMask.r = zeros(m,1);
        SkyMask.W = diag(w(idx));

        for ii = 1:m
            i = idx(ii);
            rho_hat = norm(SkyMask.Psat(i,:)' - x_est(1:3));
            pred    = rho_hat + c*x_est(4);
            SkyMask.r(ii)   = SkyMask.rho_k(i) - pred;
            u        = (x_est(1:3) - SkyMask.Psat(i,:)') / rho_hat;
            SkyMask.H(ii,1:3) = u';
            SkyMask.H(ii,4)   = -c;
        end

        % Solve for Δx
        dx = (SkyMask.H' * SkyMask.W * SkyMask.H) \ (SkyMask.H' * SkyMask.W * SkyMask.r);
        x_est = x_est + dx;
        if norm(dx) < tol, break; end
    end

    sol(k,:) = x_est';
    x0 = x_est(1);
    y0 = x_est(2);
    z0 = x_est(3);
    dt0 = x_est(4);
end

%% Post-Process for Plotting Graph
fprintf('Visible sats per epoch (min/max): %d / %d\n', min(nVis), max(nVis));
if max(nVis) < 4
    warning('All epochs have <4 visible sats under this SkyMask. Relaxing SkyMask by 2°.');
    
    % Try relaxing the SkyMask by 2 degrees and re-evaluate
    SkyMaskElVec = SkyMask.SkyMaskElVec - 2;
    sol = nan(nEpoch,4);
    for k = 1:nEpoch
        SkyMask.rho_k = SkyMask.pr(:,k);       
        SkyMask.az_k  = SkyMask.az(:,k);       
        SkyMask.el_k  = SkyMask.el(:,k);       
        SkyMask.Psat  = squeeze(SkyMask.pos(:,:,k))';  

        vis = false(nSat,1);
        w   = zeros(nSat,1);
        for i = 1:nSat
            a = mod(SkyMask.az_k(i),360);
            ai = floor(a)+1; 
            el_block = SkyMaskElVec(ai);
            if SkyMask.el_k(i) > el_block
                w(i) = sin(deg2rad(SkyMask.el_k(i) - el_block)) * sin(deg2rad(SkyMask.el_k(i)));
                vis(i) = true;
            end
        end

        idx = find(vis);
        if numel(idx) < 4, continue; end
        
        x_est = [x0; y0; z0; dt0];
        for iter = 1:10
            m = numel(idx);
            SkyMask.H = zeros(m,4);
            SkyMask.r = zeros(m,1);
            SkyMask.W = diag(w(idx));

            for ii = 1:m
                i = idx(ii);
                rho_hat = norm(SkyMask.Psat(i,:)' - x_est(1:3));
                pred = rho_hat + c * x_est(4);
                SkyMask.r(ii) = SkyMask.rho_k(i) - pred;
                u = (x_est(1:3) - SkyMask.Psat(i,:)') / rho_hat;
                SkyMask.H(ii,1:3) = u';
                SkyMask.H(ii,4) = -c;
            end

            dx = (SkyMask.H' * SkyMask.W * SkyMask.H) \ (SkyMask.H' * SkyMask.W * SkyMask.r);
            x_est = x_est + dx;
            if norm(dx) < tol, break; end
        end

        sol(k,:) = x_est';
        x0 = x_est(1);
        y0 = x_est(2);
        z0 = x_est(3);
        dt0 = x_est(4);
    end
end

valid = find(~any(isnan(sol),2));
if isempty(valid)
    disp('No valid solutions.');
    return;
end

[lat, lon, ~] = ecef2geodetic(SkyMask.wgs, sol(valid,1), sol(valid,2), sol(valid,3));
if isempty(lat) || isempty(lon)
    disp('No valid data of latitude and longitude.');
    return;
end

% Plot results
figure;
plot(lon, lat, 'r.', 'MarkerSize', 10); % Estimated positions
aver_lon = mean(lon(1:9));
aver_lat = mean(lat(1:9));
disp(aver_lon);
disp(aver_lat);
hold on;
plot(lon0, lat0, 'bx', 'MarkerSize', 10); % Ground truth
plot(aver_lon, aver_lat, 'x', 'MarkerSize', 10, 'Color', 'green'); % Ground truth
xlabel('Longitude (°)');
ylabel('Latitude (°)');
legend('Estimated Position', 'Ground Truth', 'Average Estimated Positions');
title('Calculated GNSS Positions');
grid on;