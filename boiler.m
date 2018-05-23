 function [productieProfiel, kostBoiler, kostBrand, CO2, maxVermogen, minVermogen] = boiler(type, uitlaatTemperatuur, brandstof, energievraag, jaartal)
%Deze functie beschouwd het energieaanbod van een boiler met gas of stookolie als brandstof

%% Gegevens inladen

gegevens;

[kostStookolie,kostGas,kostElek] = variabeleGegevens(jaartal);

%% Oliecondensatieketel Vitoradial 300-T VR3 101kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

if (strcmp(brandstof, 'olie') && type == 1)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 101;
        minVermogen = 0;
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 94;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 20000;
onderhoud = 300;
levensduur = 20; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostStookolie/efficientieOlieKetel;
CO2Brandstof = CO2Stookolie/efficientieOlieKetel;


%% Oliecondensatieketel Vitoradial 300-T VR3 201kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'olie') && type == 2)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 201;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 188;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 23000; 
onderhoud = 450;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostStookolie/efficientieOlieKetel;
CO2Brandstof = CO2Stookolie/efficientieOlieKetel;


%% Oliecondensatieketel Vitoradial 300-T VR3 425kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'olie') && type == 3)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 425;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 407;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 30000;
onderhoud = 600;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostStookolie/efficientieOlieKetel;
CO2Brandstof = CO2Stookolie/efficientieOlieKetel;

%% Oliecondensatieketel Vitoradial 300-T VR3 545kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'olie') && type == 4)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 545;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 522;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 35000;
onderhoud = 700;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostStookolie/efficientieOlieKetel;
CO2Brandstof = CO2Stookolie/efficientieOlieKetel;

%% Gascondensatieketel Vitocrossal 100 CI1 80kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'gas') && type == 1)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 80;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 74;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 8000; 
onderhoud = 150;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostGas/efficientieGasKetel; 
CO2Brandstof = CO2Gas/efficientieGasKetel;

%% Gascondensatieketel Vitocrossal 100 CI1 200kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'gas') && type == 2)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 200;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 184;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 12000;
onderhoud = 200;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostGas/efficientieGasKetel;
CO2Brandstof = CO2Gas/efficientieGasKetel;


%% Gascondensatieketel Vitocrossal 100 CI1 400kW
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'gas') && type == 3)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 400;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 368;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 28000; 
onderhoud = 250;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostGas/efficientieGasKetel;
CO2Brandstof = CO2Gas/efficientieGasKetel;

%% Gascondensatieketel Vitocrossal 100 CI1 Twin boiler 560W
% Uitlaat- en retourtemperatuur: 50/30°C of 80/60°C

elseif (strcmp(brandstof, 'gas') && type == 4)
    if(uitlaatTemperatuur == 50)
        maxVermogen = 560;
        minVermogen = 0; 
    elseif(uitlaatTemperatuur == 80)
        maxVermogen = 520;
        minVermogen = 0; 
    end

% Berekening kost & CO2
investeringKost = 35000; 
onderhoud = 300;
levensduur = 15; 
kostBoiler = investeringKost/levensduur + onderhoud;
kostBrandstof = kostGas/efficientieGasKetel;
CO2Brandstof = CO2Gas/efficientieGasKetel;

end

%% Bepaling productieprofiel
if ((1*maxVermogen >= energievraag) && (energievraag >= 1*minVermogen))
    kostBrand = kostBrandstof; 
    CO2Brand = CO2Brandstof;
    productieProfiel = energievraag;
elseif energievraag > 1*maxVermogen
    kostBrand = kostBrandstof;
    CO2Brand = CO2Brandstof;
    productieProfiel = 1*maxVermogen;
else
    kostBrand = 0;
    CO2Brand = 0;
    productieProfiel = 0;
end

%% Kost berekening per kWh gebeurd in Main file

%% CO2 berekening per kWh

CO2 = CO2Brand;

end


