function [productieProfiel, opslagProfiel, inhoudNa, kost, CO2] = buffervat(vraagProfiel, aanbodProfiel, inhoudVoor, type, jaartal)
% Deze functie bepaald de opslag van warmte
% We beschouwen 3 types: geen buffervat, buffervat van 10000 liter, en ecovat
% Input vraagProfiel: hoeveel extra energie er nodig is uit het buffervat (kWh)
% Input aanbodProfiel: hoeveel extra energie er geleverd kan worden aan het buffervat (kWh)
% Output productieProfiel: hoeveel energie het buffervat effectief levert (is minder of gelijk aan vraagProfiel)
% Output opslagProfiel: hoeveel energie er effectief is opgeslaan in het buffervat (is minder of gelijk aan het aanbodProfiel)

%% Gegevens inladen

gegevens;

[kostStookolie,kostGas,kostElek] = variabeleGegevens(jaartal);

%% Geen buffervat 

if(strcmp(type, 'geen'))
    productieProfiel = 0;
    opslagProfiel = 0; 
    inhoudNa = inhoudVoor;
end  

%% Klein buffervat EnerVal type G 2500
% Nominaal volume 2361 liter, 
% Standby losses: 187W
% Capaciteit = 151 kWh %Thermoclines: 25-80°C -> 55*2361*4,19/3600 = 151,14

if(strcmp(type, 'klein'))
    capaciteit = 151; 
    productieProfiel = 0;
    opslagProfiel = 0;
    inhoud = inhoudVoor;
    
    if(vraagProfiel > aanbodProfiel)
            while((inhoud > 0) && (productieProfiel < (vraagProfiel - aanbodProfiel)))
                inhoud = inhoud - 1;
                productieProfiel = productieProfiel + 1;
            end
            inhoudNa = inhoud;
            opslagProfiel = 0;
            
    elseif(vraagProfiel == aanbodProfiel)
            productieProfiel = 0;
            opslagProfiel = 0;
            inhoudNa = inhoudVoor;
        
    elseif (vraagProfiel < aanbodProfiel)
            while(inhoud < capaciteit && (opslagProfiel < (aanbodProfiel - vraagProfiel)))
                inhoud = inhoud + 1;
                opslagProfiel = opslagProfiel + 1;
            end
                inhoudNa = inhoud;
                productieProfiel = 0;
    end
    inhoudNa = inhoudNa - (inhoudNa/capaciteit)*0.187; %Verval in buffervat
end

%% Ecovat
% Ecovat met een diameter van 30m en 8 lagen heeft een thermische capaciteit van 1184 MWh/cyclus
% De efficientie over 6 maanden is 91%

if(strcmp(type, 'ecovat'))
    capaciteit = 1184000;
    productieProfiel = 0;
    opslagProfiel = 0;
    inhoud = inhoudVoor;
    
    if(vraagProfiel > aanbodProfiel)
            while((inhoud > 0) && (productieProfiel < (vraagProfiel - aanbodProfiel)))
                inhoud = inhoud - 1;
                productieProfiel = productieProfiel + 1;
            end
            inhoudNa = inhoud;
            opslagProfiel = 0;
            
    elseif(vraagProfiel == aanbodProfiel)
            productieProfiel = 0;
            opslagProfiel = 0;
            inhoudNa = inhoudVoor;
        
    elseif (vraagProfiel < aanbodProfiel)
            while(inhoud < capaciteit && (opslagProfiel < (aanbodProfiel - vraagProfiel)))
                inhoud = inhoud + 1;
                opslagProfiel = opslagProfiel + 1;
            end
                inhoudNa = inhoud;
                productieProfiel = 0;
    end
    inhoudNa = inhoudNa*(1-0.09/4380); %Verval in buffervat
end

%% Kost en CO2 berekening per kWh

if(strcmp(type, 'geen'))
    
    kost = 0;
    CO2 = 0;

elseif(strcmp(type, 'klein'))
    investeringKost = 3000; %Eénmalige investeringskost
    onderhoud = 100; 
    levensduur = 25;
    aandeelWarmtepomp = 32461; %%%%% Energieoverschot van Dijle opgeslaan in ecovat in 1 jaar %%%%% Invullen na iteratie
    SPF = 4.76;
    
    kostBuffervat = (investeringKost/levensduur)/aandeelWarmtepomp + (onderhoud/aandeelWarmtepomp);
    kostElektriciteit = kostElek/SPF;
    kostBrandstof = kostGas/efficientieGasKetel;
    kost = kostBuffervat + (aandeelWarmtepomp*kostElektriciteit)/aandeelWarmtepomp;

    CO2 = CO2Elek/SPF;
    
elseif(strcmp(type, 'ecovat'))
    investeringKost = 2000000; %Eénmalige investeringkost
    onderhoud = 2000;
    levensduur = 100;
    aandeelWarmtepomp = 400000; %Energieoverschot van Dijle opgeslaan in ecovat in 1 jaar %%%%% Invullen na iteratie
    SPF = 4.25;
    aandeelBoiler = 26000; %Energieoverschot van boiler opgeslaan in ecovat in 1 jaar %%%%% Invullen na iteratie
    
    kostEcovat = (investeringKost/levensduur)/(aandeelWarmtepomp+aandeelBoiler) + (onderhoud/(aandeelWarmtepomp+aandeelBoiler));
    kostElektriciteit = kostElek/SPF;
    kostBrandstof = kostGas/efficientieGasKetel;
    kost = kostEcovat + (aandeelWarmtepomp*kostElektriciteit + aandeelBoiler*kostBrandstof)/(aandeelWarmtepomp+aandeelBoiler);

    CO2 = (aandeelWarmtepomp*(CO2Elek/SPF) + aandeelBoiler*(CO2Gas/efficientieGasKetel))/(aandeelWarmtepomp+aandeelBoiler);
    
end

