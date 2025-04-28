# Assignment2

## Question 1: Comparing the pros and cons for the following GNSS techniques for smartphone navigation: Differential GNSS (DGNSS), Real-Time Kinematic (RTK), Precise Point Positioning (PPP), and PPP-RTK

This essay aims at comparing the advantages and limitations of differential GNSS (DGNSS), real-time kinematic (RTK), precise point positioning (PPP), and PPP-RTK techniques.

### Differential GNSS (DGNSS)

DGNSS enhances GNSS accuracy by using fixed ground-based reference stations. These stations calculate the difference between their true position and the GNSS-determined position, then broadcast this correction data to nearby smartphone GNSS receivers, reducing positioning errors to about 1 meter.

#### Advantages

One major advantage of DGNSS is its improved accuracy. Traditional GNSS can have significant errors, especially in urban areas with closely spaced streets. For example, a user on Street A might be shown on nearby Street B, complicating navigation. DGNSS reduces positioning errors to within one to two meters, allowing for more precise navigation. This means the map can accurately show the user on Street A, making it easier to reach their destination. Thus, DGNSS enhances smartphone navigation accuracy, making it more reliable and suitable for widespread use.

Another advantage of DGNSS in smartphone navigation is its ability to provide real-time corrections. This ensures quick position updates, which are essential for dynamic applications like location-based services and turn-by-turn navigation. With DGNSS, these applications can respond instantly, enhancing their usability.

Additionally, DGNSS is cost-effective. It offers high positioning accuracy without significantly increasing production costs, making it feasible to integrate into more smartphones. This is particularly beneficial for price-sensitive consumers, as it provides precise navigation without making smartphones too expensive.

#### Limitations

The accuracy and availability of DGNSS heavily depend on distance between the smartphone and the ground-based reference stations. As the distance from these stations increases, DGNSS accuracy decreases, making precise positioning difficult for users far from the stations. Additionally, the broadcast signals have limited coverage, so users outside this area cannot receive correction data. This reliance on proximity to reference stations limits DGNSS's effectiveness in remote or poorly covered areas, negatively impacting its overall reliability for smartphone navigation.

### Real-Time Kinematic (RTK)

RTK achieves high-precision positioning by using carrier-phase measurements from a fixed ground base station and the smartphone's GNSS antenna. The ground station broadcasts correction data to the smartphone, enabling centimeter-level positioning accuracy.

#### Advantage

RTK has a high precision, which is crucial for certain smartphone applications requiring very precise measurements. For instance, "lane-level navigation" in map applications in smartphone needs to accurately determine which lane a user is in on a road. The centimeter-level positioning accuracy offered by RTK would make very precise positioning in smartphone applications possible (such as the "lane-level navigation").

#### Limitations

RTK's accuracy and availability are highly dependent on the distance between the smartphone and the base station. As the distance increases, RTK's accuracy decreases, limiting its effectiveness to a small range (typically several kilometers) from the base station. In remote areas where the smartphone cannot receive signals from the base station, RTK fails to provide precise positioning. This limitation restricts its wide application in smartphone navigation.

### Precise Point Positioning (PPP)

PPP uses precise satellite orbit and clock information to achieve high accuracy without a local reference station.

#### Advantages

PPP offers global coverage without needing ground-based stations. As long as GNSS signals are available, smartphone users can enjoy precise positioning even in remote areas with poor infrastructure.

In addition to the global coverage,  PPP offers high accuracy positioning and navigation. After the positioning solution is converaged, PPP can achieve decimeter-level accuracy and even centimeter-level accuracy under suitable conditions, enabling precise positioning applications on smartphones.

#### Limitations

PPP requires the convergence of positioning data, making it less suitable for real-time use on smartphones. It typically takes 15 to 30 minutes for PPP to achieve high accuracy, which is not ideal for applications needing immediate positioning data. Additionally, the convergence process is computationally demanding, which may be challenging for some smartphones with limited resources.

Furthermore, PPP's positioning accuracy is generally worse than RTK. PPP typically achieves decimeter-level accuracy, while RTK offers centimeter-level accuracy. Therefore, PPP is less suitable for smartphone applications requiring very precise positioning data.

### PPP-RTK

PPP-RTK combines elements of both PPP and RTK in an attempt to provide high precision (from RTK) and global coverage (from PPP).

#### Advantages

PPP-RTK merges the advantages of RTK and PPP. RTK offers centimeter-level precision, while PPP provides global coverage by relying solely on GNSS signals from satellites, without the need for ground-based reference stations. This means that when smartphone users are within the signal coverage of an RTK base station, they can achieve very high precision navigation. Conversely, when users are outside the coverage of the RTK base station, they can still enjoy precise navigation using PPP. This combination ensures that users benefit from both high precision and extensive coverage from PPP-RTK technology.

Another advantage of PPP-RTK is the fast convergence time. PPP-RTK considers both the preceise satellite orbit and clock corrections from PPP and the real-time atmospheric corrections and regional reference network data from RTK, which allows PPP-RTK to achieve precise navigation with faster convergence. It is important to smartphone users since some applications require instantaneous position data from GNSS such as the real-time navigation.

#### Limitations

Implementing PPP-RTK in smartphones increases both cost and complexity, potentially hindering widespread adoption. The GNSS antennas and receivers needed to process both PPP and RTK corrections are expensive, raising production costs and selling prices of smartphone. Additionally, real-time data processing for PPP-RTK is computationally demanding, requiring high-performance CPUs. This limits its feasibility for smartphones with limited computational capabilities, affecting the wide-scale use of PPP-RTK.

(884 words)

## Task 2: GNSS in Urban Areas

After the MATLAB codes for Assignment 1 are run, the variable `navSolutions` that store the necessary information for GNSS navigation such as satellite clock correction, psuedorange measurement and satellite position is obtained. Then, the data in `navSolutions` are further processed by executing the codes in `skymask_gnass.m` for improving the GNSS localization accuracy with Skymask information. The Skymask information is loaded in `skymask_gnass.m` with the codes:

```
...
M = readmatrix('C:\Users\owner\Documents\MATLAB\GPS\skymask_A1_urban.csv');
...
```

The figure of Skymask in which the blocking elevation in degree is plotted as a function of azimuth in degree is as follows:

![Task2_1](https://github.com/user-attachments/assets/d0aa626f-08ab-4fbf-bd38-9d21d872aa1a)

After the Skymask data is loaded, the data from GNSS satellite(s) that is/are non-line-of-sight from the GNSS receiver are removed with the following codes:

```
...
maskElVec = mask.maskElVec - 2;
        sol = nan(nEpoch,4);
        for k = 1:nEpoch
            mask.rho_k = mask.pr(:,k);       
            mask.az_k  = mask.az(:,k);       
            mask.el_k  = mask.el(:,k);       
            mask.Psat  = squeeze(mask.pos(:,:,k))';  

            vis = false(nSat,1);
            w   = zeros(nSat,1);
            for i = 1:nSat
                a = mod(mask.az_k(i),360);
                ai = floor(a)+1; 
                el_block = maskElVec(ai);
                if mask.el_k(i) > el_block
                    w(i) = sin(deg2rad(mask.el_k(i) - el_block)) * sin(deg2rad(mask.el_k(i)));
                    vis(i) = true;
                end
            end

            idx = find(vis);
            if numel(idx) < 4, continue; end
            
            x_est = [x0; y0; z0; dt0];
            for iter = 1:10
                m = numel(idx);
                mask.H = zeros(m,4);
                mask.r = zeros(m,1);
                mask.W = diag(w(idx));

                for ii = 1:m
                    i = idx(ii);
                    rho_hat = norm(mask.Psat(i,:)' - x_est(1:3));
                    pred = rho_hat + c * x_est(4);
                    mask.r(ii) = mask.rho_k(i) - pred;
                    u = (x_est(1:3) - mask.Psat(i,:)') / rho_hat;
                    mask.H(ii,1:3) = u';
                    mask.H(ii,4) = -c;
                end

                dx = (mask.H' * mask.W * mask.H) \ (mask.H' * mask.W * mask.r);
                x_est = x_est + dx;
                if norm(dx) < tol, break; end
            end

            sol(k,:) = x_est';
            x0 = x_est(1);
            y0 = x_est(2);
            z0 = x_est(3);
            dt0 = x_est(4);
        end
...
```

The calculated user's antenna position is summarized in the below figure:

![Task2_2](https://github.com/user-attachments/assets/916dae7d-94fe-4259-a1af-cca75df4ea83)

The average estimated GNSS position is (114.2078, 22.3195), which deviates 140.2 meters from the ground truth. In task 1, the difference between the average estimated GNSS position and the ground truth is 157.9 meters, which shows that introducing skymask data in the processing of GNSS position can help improving the GNSS positioning accuracy in urban environment.

## Task 3:

## Task 4: Discussion on the difficulties and challenges of using LEO communication satellites for GNSS navigation

Low Earth Orbit (LEO) satellites, which orbit at altitudes between 200 and 2,000 kilometers, offer low latency and high data throughput in data transmission. However, their use in GNSS presents various challenges and difficulties, which this essay is going to explore.

The first challenge and difficulty is the high costs due to the limited signal coverage of the fast-moving LEO satellites. When a satellite is in an orbit with lower altitude, its signal coverage area is smaller. However, signals from at least 4 GNSS satellites are required for positioning. These implies that more LEO GNSS satellites must be deployed to provide global coverage. Furthermore, since the orbit altitude of LEO satellites are relatively low, these satellites are required to have a higher orbit speed. It implies that a LEO satellite may be observed by the ground GNSS satellites for a very short period of time before it moves out of the line-of-sight range. It may further require more LEO GNSS satellites for ensuring consistent LEO GNSS signal coverage. Since a GNSS satellite is equipped with advanced technology for maintaining accurate satellite time, processing signal and communication, and transmitting signals to the users, deploying more GNSS satellite implies that the costs for producing and launching such a large GNSS constellations would probably be higher accordingly.

The second challenge is the potential degraded positioning accuracy due to stronger signal interference. Since the LEO satellites are closer to the Earth's surface, the signals tend to be more susceptible to atmospheric disturbances such as ionospheric delays and tropospheric delays, which would introduce a higher magnitude of GNSS positioning error. Furthermore, since LEO are moving closer to the Earth's surface, the elevation angle tends to be lower compared to the satellites with higher orbit altitude. It implies that the LEO satellites are more prone to multipath effects especially in urban canyons in which reflected signals are received by the GNSS receiver in addition to the line-of-sight signals. It would make the GNSS positioning less accurate.

The third challenge is the higher magnitude of Doppler shift in signals from LEO satellites. Since the orbital speed for LEO satellites are higher, the relative velocity between the ground GNSS receiver and the LEO satellites are higher, which causes a larger magnitude of Doppler shifts. It might make the signal acquisition and processing algorithms more complicated since the frequench change due to significant Doppler shifts have to be considered for ensuring an accurate positioning solutions. If the Doppler shift fails to be addressed properly, the accuracy positioning solutions may be degraded significantly. It implies that the significant Doppler shifts due to the fast-moving LEO GNSS satellites may introduce positioning error in addition to making the signal acquisition and processing algorithms more complicated.

The fourth challenge associated with LEO GNSS satellites is their shorter lifetime. Being closer to Earth's surface, LEO satellites experience higher air particle density, leading to increased aerodynamic drag, which gradually slows them down and causes altitude loss. Additionally, LEO satellites are more affected by solar activity, such as solar flares and geomagnetic storms, which heat and expand Earth's atmosphere. This expansion increases atmospheric density in LEO, further enhancing drag and accelerating altitude loss. To counteract this, LEO satellites must burn more fuel to maintain their speed and altitude. Since onboard fuel is limited, this increased fuel consumption significantly shortens their operational lifespan. Consequently, more GNSS satellites need to be deployed more frequently, raising production and launch costs.

Another challenge associated with the LEO satellite is the increased computational load. Since the LEO satellites are moving rapidly, the satellite geometry relative to the GNSS receiver changes faster. Hence, the calculations of the instantaneous positions of GNSS LEO satellites tend to be more complicated with more frequent update. It implies that the computational loadings in both the GNSS LEO satellites and the GNSS receiver is higher than the traditional GNSS systems. It may make the devices having the computational power just capable to handle calculations for traditional GNSS systems incapable to handle the positioning calculation from LEO GNSS satellites.

The last challenge would be the increased management cost. Since the signal coverage areas of LEO GNSS satellites tend to be smaller, the number of ground stations responsible for providing correction data (such as satellite clock) to the satellites increases. It implies that the costs for managing the satellites increase when more ground stations have to be built. Furthermore, constant satellite corrections (such as the orbital correction and satellite clock correction) and coordinations (such as maintaining uniform satellite clock time among all satellites) are required so that these LEO GNSS satellites behave as a cohesive system while each satellite maintains at its own desired orbit. More satellites may imply that the management procedures in satellite corrections and coordinations work would be more complicated, which would increase the operating costs in managing the GNSS constellation.

(808 words)

## Task 5: the impact of GNSS Reflectometry (GNSS-R) in remote sensing

GNSS Reflectometry (GNSS-R) uses reflected GNSS signals from Earth's surfaces, like water bodies or land, to gather geophysical data. GNSS satellites broadcast signals that reflect back upon touching the Earth's surface. By measuring the time delay and phase differences between direct and reflected signals, one can estimate surface properties such as roughness, moisture content, and vegetation cover. Thus, GNSS-R is useful for remote sensing. This essay discusses its applications, advantages, and challenges in remote sensing.

### Applications of GNSS-R

The first application of GNSS-R is in soil moisture estimation. The soil moisture contents, which can be estimated via the analysis on the reflected GNSS signals from the Earth's surface, is an important information to agriculture, hydrology and climate modeling. Compared to the traditional method, GNSS-R eliminates the need of large-scale deployment of ground-based sensors in a large area for soil moisture estimation, making GNSS-R having high efficiency and economic in estimating soil moisture.

The second application of GNSS-R is in oceanography, which is to study the sea surface conditions. After the reflected GNSS signals from the sea surface is analyzed, the sea information such as the sea surface height, wave height, and wind speed can be obtained. With the above information, the ocean dynamics, sea level rise, and climate change can be understood while weather can be forecasted. Hence, a large area of ocean can be monitored with high temporal resolution with GNSS-R that the traditional methods may fail to achieve.

The third application of GNSS-R is on vegetation monitoring. The information of surface roughness and dielectric properties can be inferred from the reflected GNSS signals, and such the properties can be analyzed to estimate the vegetation health, biomass, land use, and surface conditions. This application is important for ecological studies, agriculture, land management and disaster response. Compared to the existing methods, GNSS-R enables continuous monitoring of the vegetation conditions.

The fourth application is on cryosphere monitoring. The ice thickness, snow depth and the change in ice cover can be estimated via the reflected GNSS signals. This information is important because climate change on polar regions can be studied to predict the future trends in ice melt and the rise in sea level.

Another application is to monitor the atmoshpere. The atmospheric conditions can be analyzed by examining the reflected signals which have passed through different layers in the atmosphere. Hence, the atmospheric water vapor contents, temperature profile and ionospheric disturbances can be evaluated, which is beneficial to weather forecasting and climate studies.

The last application is on the microplastic detection in the sea. The scattering properties of the ocean surface would be changed due to the existence of microplastic in the ocean. By analzing the amplitude and phase of the reflected signals, the microplastic concentration in the sea can be identified.

### Advantages of GNSS-R

The first advantage is high cost-effectiveness. Compared to the existing sensing technologies, GNSS-R eliminates the need to deploy a large number of ground-based sensors to the areas requiring sensing. Furthermore, it may also eliminate the need to deploy satellites specialized for monitoring the areas requiring sensing. The elimination of the deployment of the ground-based sensors or the satellites specialized for monitoring can make the monitoring more economic.

The second advantage is the global coverage. The ground-based sensors used in the existing sensing technology can only provide sensing coverage locally, meaning that there exists a finite sensing range. Monitoring outside the sensing range is impossible. However, the GNSS-R enables global coverage, implying that monitoring the remote areas and inaccessible places can also be done with GNSS-R, where the traditional sensing technology usually fail to do so.

The third advantage is all-weather capability. The sensing effectiveness of some existing sensing technologies such as visible sensors (that use visible lights for monitoring) tend to be easily affected by the weather conditions. However, the L-Band signals used in the GNSS-R have a large enough wavelength that is highly effective in penetrating through clouds and raining with small attenuation. It implies that the sensing effectiveness of GNSS-R tends to be independent of the weather conditions.

The fourth advantage is that the sensing is non-destructive and non-invasive. Some existing sensing technologies require sensors to be installed into the ground, which may somehow alter, in an irreversible manner, the structures and properties of the items to be monitored. It may be particularly harmful to monitor environments sensitive to change such as the protected ecosystems and polar regions. With GNSS-R, the monitoring can be performed with minimal disturbance to the environment.

The last advantage is high temporal resolution. Due to the technology limitations, some sensing methods used in the existing sensing technology may be sampling-based, meaning that a relatively large time interval (may be in the order of hour) exists between samples. However, GNSS-R enables continuous monitoring as the GNSS satellites sends GNSS signals continuously. This feature is important for monitoring dynamic environments in industries such as the weather observatory.

(818 words)
