function [productieProfiel, kost, CO2, COP] = dijle(type, uitlaattemperatuur, systeem, loop, jaartal)
% Deze functie beschouwd het energieaanbod van de Dijle

%% Gegevens inladen

gegevens;

[kostStookolie,kostGas,kostElek] = variabeleGegevens(jaartal);

temperatuurPerUur = load('temperatuurDijlePerUurMat');
tempUur = temperatuurPerUur.temperatuurDijlePerUurMat;

debietPerDag = load('debietDijlePerDagMat');
debietDag = debietPerDag.debietDijlePerDagMat;

%% Energieaanbod Dijle
% Temperatuur- daling of stijging van Dijle gelimiteerd op 3°C
% 
% deltaT = max(min(3,tempUur-3),0);
% totaleEnergieBeschikbaar = dichtheidWater*soortelijkeWarmte.*deltaT.*(debietDag/24)./10.^3;  %(kWh per uur)
% 
% % figure(1)
% % plot(totaleEnergieBeschikbaar)
% % xlabel('[Dagen]')
% % ylabel('kWh')
% % title('Energieaanbod Dijle')
% % axis([0 8760 0 inf])

%% Effectief energieaanbod Dijle mbv warmtepomp

[vermogen, COP, investeringKost1Jaar] = warmtepomp(type, tempUur(loop), uitlaattemperatuur, systeem); 

productieProfiel = 1*vermogen;

%% Kost berekening per kWh

energieGeleverdPerJaar = 100000;  %%%%% Energie geleverd per jaar rechtstreeks aan Werktuigkunde %%%%% Invullen na iteratie 
kostWarmtepomp = investeringKost1Jaar/energieGeleverdPerJaar; %Investering kost warmtepomp per kWh.
if COP == 0
    kostElektriciteit = 0; %Elektriciteitskost warmtepomp 
else
    kostElektriciteit = kostElek/COP;
end
kost = (kostWarmtepomp + kostElektriciteit); 

%% CO2 berekening per kWH
if COP == 0
    CO2 = 0;
else
    CO2 = CO2Elek/COP; 
end
end