%% Dit matlab-script bevat alle basisgegevens voor de functies (kost en CO2)

%% Efficiëntie's
efficientieGasKetel = 0.97; %Bovenste verbrandingswaarde (Eandis verkoopt volgens calorische bovenwaarde)
efficientieOlieKetel = 0.9; %Bovenste verbrandingswaarde

%% CO2 uitstoot hedendaagse technieken
CO2Stookolie = 0.306; % LCA emission factor [kg CO2/kWh] 
CO2Gas = 0.240; % LCA emission factor [kg CO2/kWh] 
CO2Elek = 0.239; % LCA emission factor [kg CO2/kWh]
CO2Certificaat = 13; % http://markets.businessinsider.com/commodities/co2-emissionsrechte 

%% Eigenschappen Dijle
dichtheidWater = 1000; %[kg/m3]
soortelijkeWarmte = 4180;  %J/(kg*K)