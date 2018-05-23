function [verbruikPerUur] = verbruikzonderpeakshaving(gebouw1, gebouw2)
%% Deze functie bepaald het totaal warmteverbruik per uur.
% Mogelijke inputs zijn 'mechanica', 'bioScience' of '/'.

%% Gegevens inladen
dagen = zeros(365,1);
for i = 1:365
    dagen(i) = i;
end

graaddagen = load('graaddagenPerDagMat');
graaddagenPerDag = graaddagen.graaddagenPerDagMat; %zomer 2013/zomer 2014 - Referentietemperatuur: 17°C

verbruik = load('verbruikPerDagMat');
verbruikPerDag = verbruik.verbruikPerDagMat; %zomer 2013/zomer 2014

graaddagen2014 = load('graaddagen2014Mat');
graaddagenPerDag2014 = graaddagen2014.graaddagen2014Mat; %2014 - Referentietemperatuur: 14°C

%% Simuleer verbruik nieuwbouw adhv verbruik oud gebouw (met lagere referentietemperatuur)
% y = 797*x (95% betrouwbaarheidsgrens, weekdagen) - Correlatie weekdagen
% y = 353.2*x (95% betrouwbaarheidsgrens, weekends) - Correlatie weekenddagen

% Aandeel sanitair warm water bepalen
sanitairWarmWater = 0;
counter = 0;
for i = 1:365
    if graaddagenPerDag(i) == 0
        sanitairWarmWater = sanitairWarmWater + verbruikPerDag(i);
        counter = counter + 1;
    end
end
sanitairWarmWaterPerDag = sanitairWarmWater/counter;

% Verbruik nieuwbouw
totaalVerbruikNieuw = zeros(365,1);
i = 1;
while i < 365
    totaalVerbruikNieuw(i+1:i+5) = 797*graaddagenPerDag2014(i+1:i+5) + sanitairWarmWaterPerDag; 
    totaalVerbruikNieuw(i+6:i+7) = 353.2*graaddagenPerDag2014(i+6:i+7) + sanitairWarmWaterPerDag;
    i = i+7;
end

%Herschaling oppervlakte (oppervlakte nieuwbouw = 3250 m², oppervlakte oud gebouw = 7500 m²)
totaalVerbruikNieuw = totaalVerbruikNieuw*(3250/7500); 


%% Plot verbruik en graaddagen per dag nieuwbouw - Plot heat demand-degree days new building
figure(1) 
yyaxis left
plot(dagen,graaddagenPerDag2014)
ylabel('Graaddagen')
xlabel('[Dagen]')
axis([0 365 0 30])
hold on
yyaxis right
ylabel('Verbruik [kWh]')
plot(dagen,totaalVerbruikNieuw)
axis([0 365 0 6000])
legend('Graaddagen','Verbruik')
title('Gesimuleerd totaal verbruik nieuwbouw Mechanica (graaddagen 2014)')


%% Opdeling verbruik nieuwbouw per uur - (peakshaving toegepast)
if gebouw1 == 'mechanica'
    verbruikPerUurM = zeros(8760,1);
    for i = 1:365
        % 1-4 uur
        verbruikPerUurM(24*(i-1)+1:24*(i-1)+4) = totaalVerbruikNieuw(i)*(1/75);
        % 5-6 uur
        verbruikPerUurM(24*(i-1)+5:24*(i-1)+6) = totaalVerbruikNieuw(i)*(2/75);
        % 7-9 uur
        verbruikPerUurM(24*(i-1)+7:24*(i-1)+9) = totaalVerbruikNieuw(i)*(9/75);
        % 10-19 uur
        verbruikPerUurM(24*(i-1)+10:24*(i-1)+19) = totaalVerbruikNieuw(i)*(3.5/75);
        % 20-24 uur
        verbruikPerUurM(24*(i-1)+20:24*(i-1)+24) = totaalVerbruikNieuw(i)*(1/75);
    end
end
    
if gebouw2 == 'bioScience'   %34.2 kWh bijtellen als baseload zodat totaal op 1.3 GWh komt
    verbruikPerUurB = zeros(8760,1);
    for i = 1:365
        % 1-6 uur
        verbruikPerUurB(24*(i-1)+1:24*(i-1)+6) = totaalVerbruikNieuw(i)*(3/102) + 34.2;
        % 7 uur
        verbruikPerUurB(24*(i-1)+7) = totaalVerbruikNieuw(i)*(7/102) + 34.2;
        % 8 uur
        verbruikPerUurB(24*(i-1)+8) = totaalVerbruikNieuw(i)*(10/102) + 34.2;
        % 9-10 uur
        verbruikPerUurB(24*(i-1)+9:24*(i-1)+10) = totaalVerbruikNieuw(i)*(7/102) + 34.2;
        % 11-19 uur
        verbruikPerUurB(24*(i-1)+11:24*(i-1)+19) = totaalVerbruikNieuw(i)*(5/102) + 34.2;
        % 20-24 uur
        verbruikPerUurB(24*(i-1)+20:24*(i-1)+24) = totaalVerbruikNieuw(i)*(3/102) + 34.2;
    end
end

% Plot verbruik per uur in tijd met peak shaving
figure(2) 
plot(verbruikPerUurM)
xlabel('Tijd [uur]')
ylabel('Verbruik [kWh]')
axis([0 8760 0 800])
title('Gesimuleerd verbruik per uur zonder peak shaving')

% Plot van 2 dagen met peak shaving
verbruik1 = verbruikPerUurM(1176:1224);
figure(3)
plot(verbruik1)
xlabel('Tijd [uur]')
ylabel('Verbruik [kWh]')
title('Aanname spreiding per dag met peak shaving')
axis([1175 1224 0 300])


%% Som verbruik beide gebouwen
if(strcmp(gebouw1, 'mechanica') && strcmp(gebouw2, 'bioScience'))
verbruikPerUur = verbruikPerUurM + verbruikPerUurB; 
end

if(strcmp(gebouw1, 'mechanica') && strcmp(gebouw2, '/'))
verbruikPerUur = verbruikPerUurM; 
end

if(strcmp(gebouw1, '/') && strcmp(gebouw2, 'bioScience'))
verbruikPerUur = verbruikPerUurB; 
end

if(strcmp(gebouw1, '/') && strcmp(gebouw2, '/'))
verbruikPerUur = zeros(8760,1); 
end

end