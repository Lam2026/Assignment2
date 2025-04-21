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

## Task 2:

## Task 3:

## Task 4: Discussion on the difficulties and challenges of using LEO communication satellites for GNSS navigation

Low Earth Orbit (LEO) satellites, which orbit at altitudes between 200 and 2,000 kilometers, offer low latency and high data throughput in data transmission. However, their use in GNSS presents various challenges and difficulties, which this essay is going to explore.

The first challenge and difficulty is the high costs due to the limited signal coverage of the fast-moving LEO satellites. When a satellite is in an orbit with lower altitude, its signal coverage area is smaller. However, signals from at least 4 GNSS satellites are required for positioning. These implies that more LEO GNSS satellites must be deployed to provide global coverage. Furthermore, since the orbit altitude of LEO satellites are relatively low, these satellites are required to have a higher orbit speed. It implies that a LEO satellite may be observed by the ground GNSS satellites for a very short period of time before it moves out of the line-of-sight range. It may further require more LEO GNSS satellites for ensuring consistent LEO GNSS signal coverage. Since a GNSS satellite is equipped with advanced technology for maintaining accurate satellite time, processing signal and communication, and transmitting signals to the users, deploying more GNSS satellite implies that the costs for producing, launching and maintaining such a large GNSS constellations would probably be higher accordingly.

The second challenge is the potential degraded positioning accuracy due to stronger signal interference. Since the LEO satellites are closer to the Earth's surface, the signals tend to be more susceptible to atmospheric disturbances such as ionospheric delays and tropospheric delays, which would introduce a higher magnitude of GNSS positioning error. Furthermore, since LEO are moving closer to the Earth's surface, the elevation angle tends to be lower compared to the satellites with higher orbit altitude. It implies that the LEO satellites are more prone to multipath effects especially in urban canyons in which reflected signals are received by the GNSS receiver in addition to the line-of-sight signals. It would make the GNSS positioning less accurate.

The third challenge is the higher magnitude of Doppler shift in signals from LEO satellites. Since the orbital speed for LEO satellites are higher, the relative velocity between the ground GNSS receiver and the LEO satellites are higher, which causes a larger magnitude of Doppler shifts. It might make the signal acquisition and processing algorithms more complicated since the frequench change due to significant Doppler shifts have to be considered for ensuring an accurate positioning solutions. If the Doppler shift fails to be addressed properly, the accuracy positioning solutions may be degraded significantly. It implies that the significant Doppler shifts due to the fast-moving LEO GNSS satellites may introduce positioning error in addition to making the signal acquisition and processing algorithms more complicated.

The fourth challenge associated with LEO GNSS satellites is their shorter lifetime. Being closer to Earth's surface, LEO satellites experience higher air particle density, leading to increased aerodynamic drag, which gradually slows them down and causes altitude loss 1. Additionally, LEO satellites are more affected by solar activity, such as solar flares and geomagnetic storms, which heat and expand Earth's atmosphere. This expansion increases atmospheric density in LEO, further enhancing drag and accelerating altitude loss2. To counteract this, LEO satellites must burn more fuel to maintain their speed and altitude. Since onboard fuel is limited, this increased fuel consumption significantly shortens their operational lifespan 3. Consequently, more GNSS satellites need to be deployed more frequently, raising production and launch costs.

Another challenge associated with the LEO satellite is the increased computational load. Since the LEO satellites are moving rapidly, the satellite geometry relative to the GNSS receiver changes faster. Hence, the calculations of the instantaneous positions of GNSS LEO satellites tend to be more complicated with more frequent update. It implies that the computational loadings in both the GNSS LEO satellites and the GNSS receiver is higher than the traditional GNSS systems. It may make the devices having the computational power just capable to handle calculations for traditional GNSS systems incapable to handle the positioning calculation from LEO GNSS satellites.



Positioning Algorithms
The algorithms used for position calculations must be robust enough to handle the unique challenges posed by LEO satellites. Given their rapid movement and the potential for frequent changes in satellite visibility, the algorithms must be continuously updated and optimized. This requirement adds complexity to the overall system design and may necessitate more advanced processing capabilities in receivers.

Operational Complexity and Cost
Implementing a LEO satellite navigation system involves not only technological challenges but also operational hurdles.

Ground Stations and Data Management
Moreover, the infrastructure supporting LEO satellites includes ground stations that must be strategically placed to ensure continuous communication with the satellites. This requirement entails significant logistical and operational planning, as well as ongoing operational costs for data management and satellite control.

Conclusion
While the potential for using Low Earth Orbit satellites for GNSS navigation exists, the challenges are considerable. Issues related to signal propagation, coverage, accuracy, and operational complexity must be addressed to create a viable LEO-based navigation system. As technology advances, there may be opportunities to mitigate some of these challenges, but the fundamental differences between LEO satellites and traditional MEO systems pose significant hurdles. For now, the integration of LEO satellites into GNSS applications will require careful consideration of these challenges and innovative solutions to ensure reliable and accurate navigation services.

## Task 5: the impact of GNSS Reflectometry (GNSS-R) in remote sensing

Global Navigation Satellite Systems (GNSS) have transformed various fields, and one of the most innovative applications is GNSS Reflectometry (GNSS-R). This technique utilizes signals from GNSS satellites reflected off surfaces, such as water bodies or land, to gather critical data about the Earth's environment. In this essay, we will explore the principles of GNSS-R, its applications, advantages, and challenges, highlighting its significant impact on remote sensing.

Principles of GNSS Reflectometry
GNSS Reflectometry leverages the signals transmitted by GNSS satellites, which are typically used for navigation. When these signals encounter surfaces, they can reflect back toward GNSS receivers. By analyzing the characteristics of these reflected signals, researchers can extract valuable information about the reflecting surfaces.

The fundamental principle behind GNSS-R lies in the measurement of the time delay and the phase differences between the direct signal and the reflected signal. This allows for the estimation of various surface properties, such as roughness, moisture content, and even vegetation cover. The technique operates under the assumption that the surface characteristics influence how the signals are reflected, making GNSS-R a powerful tool for remote sensing applications.

Applications of GNSS-R
1. Soil Moisture Estimation
One of the most significant applications of GNSS-R is in the estimation of soil moisture. Accurate soil moisture data is critical for agriculture, hydrology, and climate modeling. GNSS-R provides a cost-effective and efficient means of obtaining this data over large areas without the need for extensive ground-based sensors. By analyzing the reflected signals, researchers can infer moisture levels, which helps in optimizing irrigation practices and managing water resources.

2. Oceanography
GNSS-R is also widely used in oceanography to study sea surface conditions. The technique can provide information about sea surface height, wave height, and wind speed. These parameters are essential for understanding ocean dynamics, climate change, and weather forecasting. By utilizing GNSS signals, researchers can monitor large areas of the ocean with high temporal resolution, offering insights that traditional methods may struggle to achieve.

3. Vegetation Monitoring
In addition to soil and ocean studies, GNSS-R can be applied to monitor vegetation. By analyzing how GNSS signals reflect off vegetation canopies, researchers can assess plant health and biomass. This information is valuable for ecological studies, agriculture, and forestry management. GNSS-R allows for the continuous monitoring of vegetation conditions over vast landscapes, providing insights into ecosystem dynamics and changes due to environmental stressors.

4. Urban Studies
GNSS-R has applications in urban environments as well. It can be used to monitor changes in urban surfaces, such as the impact of construction or land use changes. By analyzing reflected signals, researchers can assess urban surface properties, including impervious surfaces and green spaces. This data is essential for urban planning and managing the urban heat island effect.

Advantages of GNSS-R
The use of GNSS-R offers several advantages over traditional remote sensing methods:

1. Cost-Effectiveness
GNSS-R requires minimal infrastructure compared to other remote sensing technologies. Existing GNSS networks can be utilized, reducing the need for extensive satellite missions or ground-based sensors, making it a cost-effective solution for large-scale monitoring.

2. High Temporal Resolution
GNSS satellites continuously transmit signals, allowing for high-frequency data collection. This characteristic is particularly beneficial for monitoring dynamic environments, such as changing weather conditions or seasonal variations in vegetation.

3. Global Coverage
The global nature of GNSS systems means that GNSS-R can be applied in remote and inaccessible areas, providing data where traditional methods may be limited. This capability is essential for comprehensive environmental monitoring and research.

Challenges and Limitations
Despite its numerous advantages, GNSS-R also faces challenges. The technique's accuracy can be influenced by factors such as multipath effects, where signals reflect off multiple surfaces before reaching the receiver, leading to erroneous data. Additionally, the dependence on GNSS satellites means that any disruptions in satellite availability or signal quality can impact data collection.

Another challenge is the need for sophisticated algorithms to process the reflected signals accurately. Researchers must develop and refine these algorithms to ensure reliable interpretations of the data, which can be complex and resource-intensive.

Conclusion
GNSS Reflectometry represents a groundbreaking advancement in remote sensing, offering innovative solutions for monitoring soil moisture, ocean conditions, vegetation health, and urban environments. Its cost-effectiveness, high temporal resolution, and global coverage make it a valuable tool for scientists and researchers. While challenges remain, ongoing advancements in technology and processing algorithms promise to enhance the accuracy and applicability of GNSS-R. As the world faces pressing environmental challenges, GNSS-R will play a crucial role in providing the data needed for informed decision-making and sustainable management of natural resources.
