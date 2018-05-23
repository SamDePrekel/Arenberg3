%% Main file
% In deze file, kunnen verschillende scenario's gekozen worden
% Voorlopig beschouwen we enkel de Dijle en een boiler als energiebron

clear all
close all
clc

%Gegevens voor betere grafieken (enkel onderstaande waarden aanpassen)
width = 5.6;     % Width in inches
height = 4.2;    % Height in inches
alw = 1.8;    % AxesLineWidth
fsz = 14;      % Fontsize
lw = 1.3;      % LineWidth
msz = 10;       % MarkerSize

% The new defaults will not take effect if there are any open figures. To
% use them, we close all figures, and then repeat the first example.
%close all;

% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultAxesFontSize',fsz);

% % Set the default Size for display
% defpos = get(0,'defaultFigurePosition');
% set(0,'defaultFigurePosition', [defpos(1) defpos(2) width*100, height*100]);?


%% Verbruik

[energieVraag] = verbruik('mechanica','/');

energieVraagTotaal1Jaar = sum(sum(energieVraag))/15;

% Plot verbruik per uur
figure
plot(energieVraag(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totale warmtevraag departement Werktuigkunde')
axis([0 8760 0 500])     


%% Scenario 1: Ecovat (Basisscenario)

gegevens;

% Verbruik
[energieVraag] = verbruik('mechanica','/');

% Aanbod
levensduur = 15;
energieAanbodDijle = zeros(8760,levensduur); %Energie uit Dijle die rechtstreeks geleverd aan Werktuigkunde
energieAanbodTotaalDijle = zeros(8760,levensduur); %Totale energie geleverd door Dijle
energieAanbodBoiler = zeros(8760,levensduur); %Energie uit boiler rechtstreeks geleverd aan Werktuigkunde
energieAanbodTotaalBoiler = zeros(8760,levensduur); %Totale energie geleverd door boiler
energieAanbodBuffervat = zeros(8760,levensduur);
energieOpslagBuffervat = zeros(8760,levensduur);
energieAanbodDijleBuffervat = zeros(8760,levensduur);
energieAanbodDijleBoiler = zeros(8760,levensduur);
energieAanbodDijleBoilerBuffervat = zeros(8760,levensduur);
energieAanbodTotaal = zeros(8760,levensduur);
energieOverschot = zeros(8760,levensduur);
energieVraagBoiler = zeros(8760,levensduur);
energieVraagBuffervat = zeros(8760,levensduur);
inhoudVoor = zeros(8760,levensduur);
energieVraagNaLevering = zeros(8760,levensduur);
COPwarmtepomp = zeros(8760,levensduur);
totaalPrijsDijle = 0; 
totaalPrijsBrandstofBoiler = 0;
totaalPrijsBuffervat = 0;
totaalCO2Dijle = 0;
totaalCO2Boiler = 0;
totaalCO2Buffervat = 0;

for i = 1:8760
    cosinus(i) = 215000*cos((i/8760)*2*pi+pi/2) + 225000;
end

for j = 1:levensduur
    treshold = 0.025*1.007^(j-1)+0.0153; %Definieer hier treshold -> Constant itereren zodat optimum gekozen wordt.
    inhoudVoor(1,1) = 225000; %half gevuld: 592000
    inhoudNa = inhoudVoor(1,j);
    for i = 1:8760
        [productieProfielDijle, kostDijle, CO2Dijle, COP] = dijle(4, 55, 'open', i, j); %Nooit op deellast laten werken
        if(kostDijle < treshold)
            energieAanbodTotaalDijle(i,j) = productieProfielDijle;
            COPwarmtepomp(i,j) = COP;
            if ((inhoudVoor(i,j) >= cosinus(i)))
                if (productieProfielDijle < energieVraag(i,j))
                    energieAanbodDijle(i,j) = productieProfielDijle;
                    totaalPrijsDijle = totaalPrijsDijle + kostDijle;   
                    totaalCO2Dijle = totaalCO2Dijle + CO2Dijle;   
                    energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodTotaalDijle(i,j));
                    [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                    energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                    if(productieProfielBuffervat > 0)
                        totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                        totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                    end
                    energieAanbodDijleBuffervat(i,j) = energieAanbodDijle(i,j) + energieAanbodBuffervat(i,j);
                    if(energieAanbodDijleBuffervat(i,j) < energieVraag(i,j))
                       energieVraagBoiler(i,j) = (energieVraag(i,j) - energieAanbodDijleBuffervat(i,j)); 
                       [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(1, 50, 'gas', energieVraagBoiler(i,j), j); 
                       energieAanbodBoiler(i,j) = productieProfielBoiler;
                       energieAanbodTotaalBoiler(i,j) = productieProfielBoiler;
                       totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                       totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                    end
                else
                   energieAanbodDijle(i,j) = energieVraag(i,j);
                   totaalPrijsDijle = totaalPrijsDijle + kostDijle;   
                   totaalCO2Dijle = totaalCO2Dijle + (energieAanbodDijle(i,j)/energieAanbodTotaalDijle(i,j))*CO2Dijle;                
                   energieOverschot(i,j) = (productieProfielDijle - energieVraag(i,j));
                   [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                   energieOpslagBuffervat(i,j) = opslagProfielBuffervat; 
                end
            elseif ((inhoudVoor(i,j) < cosinus(i)) && i<4000) 
                if(productieProfielDijle < energieVraag(i,j))
                   energieAanbodDijle(i,j) = productieProfielDijle;
                   totaalPrijsDijle = totaalPrijsDijle + kostDijle;   
                   totaalCO2Dijle = totaalCO2Dijle + CO2Dijle;    
                   energieVraagBoiler(i,j) = 600; %Boiler dient op vollast te draaien. Maximaal vermogen is altijd lager dan 600kW 
                   [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(1, 50, 'gas', energieVraagBoiler(i,j), j); 
                   energieAanbodTotaalBoiler(i,j) = productieProfielBoiler;
                   energieAanbodDijleBoiler(i,j) = energieAanbodDijle(i,j) + energieAanbodTotaalBoiler(i,j);
                    if(energieAanbodDijleBoiler(i,j) < energieVraag(i,j))
                       energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodDijleBoiler(i,j));
                       energieAanbodBoiler(i,j) = productieProfielBoiler;
                       totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                       totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;                        
                       [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                       energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                       if(productieProfielBuffervat > 0)
                           totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                           totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                       end
                    else
                       energieOverschot(i,j) = (energieAanbodDijleBoiler(i,j) - energieVraag(i,j));
                       energieAanbodBoiler(i,j) = energieAanbodTotaalBoiler(i,j) - energieOverschot(i,j); 
                       totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                       totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                       [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                       energieOpslagBuffervat(i,j) = opslagProfielBuffervat; 
                    end 
                else
                   energieAanbodDijle(i,j) = energieVraag(i,j);
                   totaalPrijsDijle = totaalPrijsDijle + kostDijle;    
                   totaalCO2Dijle = totaalCO2Dijle + (energieAanbodDijle(i,j)/energieAanbodTotaalDijle(i,j))*CO2Dijle; 
                   energieOverschot(i,j) = (energieAanbodTotaalDijle(i,j) - energieVraag(i,j));
                   [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                   energieOpslagBuffervat(i,j) = opslagProfielBuffervat;  
                end
            elseif ((inhoudVoor(i,j) < cosinus(i)) && i>=4000)
                if (productieProfielDijle < energieVraag(i,j))
                   energieAanbodDijle(i,j) = productieProfielDijle;
                   totaalPrijsDijle = totaalPrijsDijle + kostDijle;    
                   totaalCO2Dijle = totaalCO2Dijle + CO2Dijle;   
                   energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodDijle(i,j));
                   [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                   energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                   if(productieProfielBuffervat > 0)
                       totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                       totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                   end
                else
                   energieAanbodDijle(i,j) = energieVraag(i,j);
                   totaalPrijsDijle = totaalPrijsDijle + kostDijle;    
                   totaalCO2Dijle = totaalCO2Dijle + (energieAanbodDijle(i,j)/energieAanbodTotaalDijle(i,j))*CO2Dijle; 
                   energieOverschot(i,j) = (energieAanbodTotaalDijle(i,j) - energieVraag(i,j));
                   [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                   energieOpslagBuffervat(i,j) = opslagProfielBuffervat;            
                end                            
            end
        else
           energieAanbodTotaalDijle(i,j) = 0;
            if ((inhoudVoor(i,j) <= cosinus(i)) && i<4000)
               energieAanbodDijle(i,j) = 0;
               energieVraagBoiler(i,j) = 600; %Boiler dient op vollast te draaien. Maximaal vermogen is altijd lager dan 600kW 
               [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(1, 50, 'gas', energieVraagBoiler(i,j), j); 
               energieAanbodTotaalBoiler(i,j) = productieProfielBoiler; 
               if(energieAanbodTotaalBoiler(i,j) < energieVraag(i,j))
                  energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodBoiler(i,j));
                  energieAanbodBoiler(i,j) = energieAanbodTotaalBoiler(i,j);
                  totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                  totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                  [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                  energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                  if(productieProfielBuffervat > 0)
                     totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                     totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                  end
               else
                  energieOverschot(i,j) = (energieAanbodTotaalBoiler(i,j) - energieVraag(i,j));
                  energieAanbodBoiler(i,j) = energieAanbodTotaalBoiler(i,j) - energieOverschot(i,j);
                  totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                  totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                  [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                  energieOpslagBuffervat(i,j) = opslagProfielBuffervat;
               end
            else
               energieAanbodDijle(i,j) = 0;
               if(inhoudVoor(i,j) > energieVraag(i,j))
                  energieVraagBuffervat(i,j) =  energieVraag(i,j);
                  [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                  energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                  if(productieProfielBuffervat > 0)
                      totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                      totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                  end
               else
                  energieVraagBoiler(i,j) = 600; %Boiler dient op vollast te draaien. Maximaal vermogen is altijd lager dan 600kW 
                  [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(1, 50, 'gas', energieVraagBoiler(i,j), j); 
                  energieAanbodTotaalBoiler(i,j) = productieProfielBoiler;
                  if(energieAanbodTotaalBoiler(i,j) < energieVraag(i,j))
                      energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodBoiler(i,j));
                      energieAanbodBoiler(i,j) = productieProfielBoiler;
                      totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                      totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                      [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'ecovat', j);
                      energieAanbodBuffervat(i,j) = productieProfielBuffervat; 
                      if(productieProfielBuffervat > 0)
                         totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                         totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                      end
                  else
                      energieOverschot(i,j) = (energieAanbodBoiler(i,j) - energieVraag(i,j));
                      energieAanbodBoiler(i,j) = energieAanbodTotaalBoiler(i,j) - energieOverschot(i,j);
                      totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                      totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;   
                      [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'ecovat', j);
                      energieOpslagBuffervat(i,j) = opslagProfielBuffervat;
                  end
               end
            end
        end
        inhoudVoor(i+1,j) = inhoudNa;
        energieAanbodTotaal(i,j) = energieAanbodBoiler(i,j) + energieAanbodDijle(i,j) + energieAanbodBuffervat(i,j);
        energieVraagNaLevering(i,j) = energieVraag(i,j) - energieAanbodTotaal(i,j);
    end
    inhoudVoor(1,j+1) = inhoudNa;
end  


% Totaal energie aanbod per techniek per jaar
totaalAanbodTotaalDijleGemPerJaar = sum(sum(energieAanbodTotaalDijle))/15;
totaalAanbodTotaalBoilerGemPerJaar = sum(sum(energieAanbodTotaalBoiler))/15;
totaalAanbodDijleGemPerJaar = sum(sum(energieAanbodDijle))/15;
totaalAanbodBoilerGemPerJaar = sum(sum(energieAanbodBoiler))/15;
totaalAanbodBuffervatGemPerJaar = sum(sum(energieAanbodBuffervat))/15;
totaalAanbodGemPerJaar = totaalAanbodDijleGemPerJaar + totaalAanbodBoilerGemPerJaar + totaalAanbodBuffervatGemPerJaar;

% Totaal energie aanbod per techniek 15 jaren achter elkaar
inhoudVoor15Jaar = inhoudVoor(:);
energieVraagNaLevering15Jaar = energieVraagNaLevering(:);

% Kostprijs, CO2 en COP
gemiddeldeCO2Dijle = ((totaalAanbodTotaalDijleGemPerJaar/totaalAanbodDijleGemPerJaar)*totaalCO2Dijle)/numel(nonzeros(energieAanbodDijle));
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldeCO2Boiler = 0;
else
    gemiddeldeCO2Boiler = CO2Gas/efficientieGasKetel;
end
gemiddeldeCO2Buffervat = totaalCO2Buffervat/numel(nonzeros(energieAanbodBuffervat));
gemiddeldeCO2Totaal = (gemiddeldeCO2Dijle*totaalAanbodDijleGemPerJaar + gemiddeldeCO2Boiler*totaalAanbodBoilerGemPerJaar + gemiddeldeCO2Buffervat*totaalAanbodBuffervatGemPerJaar)/totaalAanbodGemPerJaar;

penaltyCO2Dijle = CO2Certificaat*gemiddeldeCO2Dijle/1000;
penaltyCO2Boiler = CO2Certificaat*gemiddeldeCO2Boiler/1000;

gemiddeldePrijsDijle = (totaalPrijsDijle)/numel(nonzeros(energieAanbodDijle)) + penaltyCO2Dijle;
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldePrijsBoiler = 0;
else
    gemiddeldePrijsBoiler = totaalPrijsBrandstofBoiler/numel(nonzeros(energieAanbodBoiler)) + kostBoiler/totaalAanbodBoilerGemPerJaar + penaltyCO2Boiler;
end
gemiddeldePrijsBuffervat = totaalPrijsBuffervat/numel(nonzeros(energieAanbodBuffervat));
gemiddeldePrijsTotaal = (gemiddeldePrijsDijle*totaalAanbodDijleGemPerJaar + gemiddeldePrijsBoiler*totaalAanbodBoilerGemPerJaar + gemiddeldePrijsBuffervat*totaalAanbodBuffervatGemPerJaar)/totaalAanbodGemPerJaar;
gemiddeldeCOPtotaal = (sum(sum(COPwarmtepomp))/numel(nonzeros(COPwarmtepomp)));


% Plots met het aandeel van elke energiebron (Dijle/boiler/buffervat)

figure
plot(energieVraag(:,1));
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totale warmtevraag')
axis([0 8760 0 500])   

figure
plot(energieAanbodDijle(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod Dijle rechtreeks benut in Werktuigkunde')
axis([0 8760 0 500]) 

figure
plot(energieAanbodTotaalDijle(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totaal energieaanbod Dijle')
axis([0 8760 0 500])

figure
plot(COPwarmtepomp(:,1))
xlabel('Tijd [h]')
ylabel('COP')
title('COP warmtepomp')
axis([0 8760 0 8])

figure
plot(energieAanbodBoiler(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod boiler rechtstreeks benut in Werktuigkunde')
axis([0 8760 0 500]) 

figure
plot(energieAanbodTotaalBoiler(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totaal energieaanbod boiler')
axis([0 8760 0 500]) 

figure
plot(energieAanbodBuffervat(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod buffervat')
axis([0 8760 0 inf]) 

figure
plot(energieVraagNaLevering(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Resterende energievraag')
axis([0 8760 0 500])

figure
plot(inhoudVoor(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energiebeschikbaarheid van buffervat')
axis([0 8760 0 inf])

figure
plot(inhoudVoor15Jaar)
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energiebeschikbaarheid van buffervat - 15 jaren')
axis([0 131400 0 inf])

%% Scenario 2:  Buffervat 10000 liter

gegevens;

% Verbruik
[energieVraag] = verbruik('mechanica','/');

% Aanbod
levensduur = 15;
energieAanbodDijle = zeros(8760,levensduur);
energieAanbodTotaalDijle = zeros(8760,levensduur);
energieAanbodBoiler = zeros(8760,levensduur);
energieAanbodBuffervat = zeros(8760,levensduur);
energieOpslagBuffervat = zeros(8760,levensduur);
energieAanbodDijleBuffervat = zeros(8760,levensduur);
energieAanbodTotaal = zeros(8760,levensduur);
energieVraagBoiler = zeros(8760,levensduur);
energieVraagBuffervat = zeros(8760,levensduur);
inhoudVoor = zeros(8760,levensduur);
energieOverschot = zeros(8760,levensduur);
energieVraagNaLevering = zeros(8760,levensduur);
COPwarmtepomp = zeros(8760,levensduur);
totaalPrijsDijle = 0;
totaalPrijsBrandstofBoiler = 0;
totaalPrijsBuffervat = 0;
totaalCO2Dijle = 0;
totaalCO2Boiler = 0;
totaalCO2Buffervat = 0;

for j = 1:levensduur
    treshold = 0.025*1.007^(j-1)+0.0059; %Definieer hier treshold -> Constant itereren zodat optimum gekozen wordt. 0.025*1.007^(j-1)+0.0059
    inhoudVoor(1,1) = 151;
    inhoudNa = inhoudVoor(1,j);
    for i = 1:8760
        [productieProfielDijle, kostDijle, CO2Dijle, COP] = dijle(2, 35, 'open', i, j); %Nooit op deellast laten werken
        if(kostDijle < treshold)
            energieAanbodTotaalDijle(i,j) = productieProfielDijle;
            COPwarmtepomp(i,j) = COP;
            if(productieProfielDijle < energieVraag(i,j))
                energieAanbodDijle(i,j) = productieProfielDijle;
                totaalPrijsDijle = totaalPrijsDijle + kostDijle;   
                totaalCO2Dijle = totaalCO2Dijle + CO2Dijle; 
                energieVraagBuffervat(i,j) = (energieVraag(i,j) - energieAanbodDijle(i,j));
                [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'klein', j);
                energieAanbodBuffervat(i,j) = productieProfielBuffervat;
                if(productieProfielBuffervat > 0)
                    totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
                    totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
                end
                energieAanbodDijleBuffervat(i,j) = energieAanbodDijle(i,j) + energieAanbodBuffervat(i,j);
                if(energieAanbodDijleBuffervat(i,j) < energieVraag(i,j))
                    energieVraagBoiler(i,j) = (energieVraag(i,j) - energieAanbodDijleBuffervat(i,j)); 
                    [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien
                    energieAanbodBoiler(i,j) = productieProfielBoiler;
                    totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                    totaalCO2Boiler = totaalCO2Boiler + CO2Boiler; 
                end
            else
               energieAanbodDijle(i,j) = energieVraag(i,j);
               totaalPrijsDijle = totaalPrijsDijle + (energieAanbodDijle(i,j)/energieAanbodTotaalDijle(i,j))*kostDijle;   
               totaalCO2Dijle = totaalCO2Dijle + (energieAanbodDijle(i,j)/energieAanbodTotaalDijle(i,j))*CO2Dijle;   
               energieOverschot(i,j) = (productieProfielDijle - energieVraag(i,j));
               [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(0, energieOverschot(i,j), inhoudVoor(i,j), 'klein', j);
               energieOpslagBuffervat(i,j) = opslagProfielBuffervat;
            end
        else
            energieAanbodDijle(i,j) = 0;
            energieAanbodTotaalDijle(i,j) = 0;
            if(inhoudVoor(i,j) > 0)
               energieVraagBuffervat(i,j) = energieVraag(i,j);
               [productieProfielBuffervat, opslagProfielBuffervat, inhoudNa, kostBuffervat, CO2Buffervat] = buffervat(energieVraagBuffervat(i,j), 0, inhoudVoor(i,j), 'klein', j);
               energieAanbodBuffervat(i,j) = productieProfielBuffervat;
               totaalPrijsBuffervat = totaalPrijsBuffervat + kostBuffervat;
               totaalCO2Buffervat = totaalCO2Buffervat + CO2Buffervat;
               if(energieAanbodBuffervat(i,j) < energieVraag(i,j))
                   energieVraagBoiler(i,j) = (energieVraag(i,j) - energieAanbodBuffervat(i,j));
                   [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien 
                   energieAanbodBoiler(i,j) = productieProfielBoiler;
                   totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                   totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;    
               end
            else
               energieVraagBoiler(i,j) = energieVraag(i,j); 
               [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien 
               energieAanbodBoiler(i,j) = productieProfielBoiler;
               totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
               totaalCO2Boiler = totaalCO2Boiler + CO2Boiler; 
            end
        end
        inhoudVoor(i+1,j) = inhoudNa;
        energieAanbodTotaal(i,j) = energieAanbodBoiler(i,j) + energieAanbodDijle(i,j) + energieAanbodBuffervat(i,j);
        energieVraagNaLevering(i,j) = energieVraag(i,j) - energieAanbodTotaal(i,j);
    end
    inhoudVoor(1,j+1) = inhoudNa;
end


% Totaal energie aanbod per techniek per jaar
totaalAanbodTotaalDijleGemPerJaar = sum(sum(energieAanbodTotaalDijle))/15;
totaalAanbodDijleGemPerJaar = sum(sum(energieAanbodDijle))/15;
totaalAanbodBoilerGemPerJaar = sum(sum(energieAanbodBoiler))/15;
totaalAanbodBuffervatGemPerJaar = sum(sum(energieAanbodBuffervat))/15;
totaalAanbodGemPerJaar = totaalAanbodDijleGemPerJaar + totaalAanbodBoilerGemPerJaar + totaalAanbodBuffervatGemPerJaar;

% Totaal energie aanbod per techniek 15 jaren achter elkaar
inhoudVoor15Jaar = inhoudVoor(:);
energieVraagNaLevering15Jaar = energieVraagNaLevering(:);

% Kostprijs, CO2 en COP
gemiddeldeCO2Dijle = ((totaalAanbodTotaalDijleGemPerJaar/totaalAanbodDijleGemPerJaar)*totaalCO2Dijle)/numel(nonzeros(energieAanbodDijle));
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldeCO2Boiler = 0;
else
    gemiddeldeCO2Boiler = CO2Gas/efficientieGasKetel;
end
gemiddeldeCO2Buffervat = totaalCO2Buffervat/numel(nonzeros(energieAanbodBuffervat));
gemiddeldeCO2Totaal = (gemiddeldeCO2Dijle*totaalAanbodDijleGemPerJaar + gemiddeldeCO2Boiler*totaalAanbodBoilerGemPerJaar + gemiddeldeCO2Buffervat*totaalAanbodBuffervatGemPerJaar)/totaalAanbodGemPerJaar;

penaltyCO2Dijle = CO2Certificaat*gemiddeldeCO2Dijle/1000;
penaltyCO2Boiler = CO2Certificaat*gemiddeldeCO2Boiler/1000;

gemiddeldePrijsDijle = ((totaalAanbodTotaalDijleGemPerJaar/totaalAanbodDijleGemPerJaar)*totaalPrijsDijle)/numel(nonzeros(energieAanbodDijle)) + penaltyCO2Dijle;
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldePrijsBoiler = 0;
else
    gemiddeldePrijsBoiler = totaalPrijsBrandstofBoiler/numel(nonzeros(energieAanbodBoiler)) + kostBoiler/totaalAanbodBoilerGemPerJaar + penaltyCO2Boiler;
end
gemiddeldePrijsBuffervat = totaalPrijsBuffervat/numel(nonzeros(energieAanbodBuffervat));
gemiddeldePrijsTotaal = (gemiddeldePrijsDijle*totaalAanbodDijleGemPerJaar + gemiddeldePrijsBoiler*totaalAanbodBoilerGemPerJaar + gemiddeldePrijsBuffervat*totaalAanbodBuffervatGemPerJaar)/totaalAanbodGemPerJaar;
gemiddeldeCOPtotaal = (sum(sum(COPwarmtepomp))/numel(nonzeros(COPwarmtepomp)));


% Plots met het aandeel van elke energiebron (Dijle/boiler/buffervat)

figure
plot(energieVraag(:,1));
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totale warmtevraag')
axis([0 8760 0 500])  

figure
plot(energieAanbodDijle(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod Dijle rechtstreeks benut in Werktuigkunde')
axis([0 8760 0 500]) 

figure
plot(energieAanbodTotaalDijle(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totaal energieaanbod Dijle')
axis([0 8760 0 500])

figure
plot(COPwarmtepomp(:,1))
xlabel('Tijd [h]')
ylabel('COP')
title('COP warmtepomp')
axis([0 8760 0 12])

figure
plot(energieAanbodBoiler(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod boiler')
axis([0 8760 0 500]) 

figure
plot(energieAanbodBuffervat(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod buffervat')
axis([0 8760 0 500]) 

figure
plot(energieOpslagBuffervat(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieopslag buffervat')
axis([0 8760 0 500]) 

figure
plot(energieVraagNaLevering(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Resterende energievraag')
axis([0 8760 0 500])

figure
plot(inhoudVoor(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energiebeschikbaarheid van buffervat')
axis([0 8760 -inf inf])

figure
plot(inhoudVoor15Jaar)
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energiebeschikbaarheid van buffervat - 15 jaar')
axis([0 131400 -inf inf])


%% Scenario 3: Zonder buffervat

gegevens;

% Verbruik
[energieVraag] = verbruik('mechanica','/');

% Aanbod
levensduur = 15;
energieAanbodDijle = zeros(8760,levensduur);
energieAanbodBoiler = zeros(8760,levensduur);
energieAanbodTotaal = zeros(8760,levensduur);
energieVraagBoiler = zeros(8760,levensduur);
energieVraagNaLevering = zeros(8760,levensduur);
COPwarmtepomp = zeros(8760,levensduur);
totaalPrijsDijle = 0;
totaalPrijsBrandstofBoiler = 0;
totaalCO2Dijle = 0;
totaalCO2Boiler = 0;

for j = 1:levensduur
    treshold = 0.025*1.007^(j-1)+0.00555; %Definieer hier treshold -> Constant itereren zodat optimum gekozen wordt. 0.025*1.007^(j-1)+0.00695
    for i = 1:8760
        [productieProfielDijle, kostDijle, CO2Dijle, COP] = dijle(1, 55, 'open', i, j); %Nooit op deellast laten werken
        if(kostDijle < treshold)
            COPwarmtepomp(i,j) = COP;
            energieAanbodTotaalDijle(i,j) = productieProfielDijle;
            totaalPrijsDijle = totaalPrijsDijle + kostDijle;
            totaalCO2Dijle = totaalCO2Dijle + CO2Dijle;
            if(productieProfielDijle < energieVraag(i,j))
                energieAanbodDijle(i,j) = productieProfielDijle;
                energieVraagBoiler(i,j) = (energieVraag(i,j) - productieProfielDijle); 
                [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien
                energieAanbodBoiler(i,j) = productieProfielBoiler;
                totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
                totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;
            else
               energieAanbodDijle(i,j) = energieVraag(i,j);
            end
        else
            energieVraagBoiler(i,j) = energieVraag(i,j); 
            [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien 
            energieAanbodBoiler(i,j) = productieProfielBoiler;
            totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
            totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;
        end
        energieAanbodTotaal(i,j) = energieAanbodDijle(i,j) + energieAanbodBoiler(i,j);
        energieVraagNaLevering(i,j) = energieVraag(i,j) - energieAanbodTotaal(i,j);
    end
end

% Totaal energie aanbod per techniek
totaalAanbodDijleGemPerJaar = sum(sum(energieAanbodDijle))/15;
totaalAanbodBoilerGemPerJaar = sum(sum(energieAanbodBoiler))/15;
totaalAanbodGemPerJaar = totaalAanbodDijleGemPerJaar + totaalAanbodBoilerGemPerJaar;

% Kostprijs, CO2 en SPF
gemiddeldeCO2Dijle = totaalCO2Dijle/numel(nonzeros(energieAanbodDijle));
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldeCO2Boiler = 0;
else
    gemiddeldeCO2Boiler = CO2Gas/efficientieGasKetel;
end
gemiddeldeCO2Totaal = (gemiddeldeCO2Dijle*totaalAanbodDijleGemPerJaar + gemiddeldeCO2Boiler*totaalAanbodBoilerGemPerJaar)/totaalAanbodGemPerJaar;

penaltyCO2Dijle = CO2Certificaat*gemiddeldeCO2Dijle/1000;
penaltyCO2Boiler = CO2Certificaat*gemiddeldeCO2Boiler/1000;

gemiddeldePrijsDijle = totaalPrijsDijle/numel(nonzeros(energieAanbodDijle)) + penaltyCO2Dijle;
if numel(nonzeros(energieAanbodBoiler)) == 0
    gemiddeldePrijsBoiler = 0;
else
    gemiddeldePrijsBoiler = totaalPrijsBrandstofBoiler/numel(nonzeros(energieAanbodBoiler)) + kostBoiler/totaalAanbodBoilerGemPerJaar + penaltyCO2Boiler;
end
gemiddeldePrijsTotaal = (gemiddeldePrijsDijle*totaalAanbodDijleGemPerJaar + gemiddeldePrijsBoiler*totaalAanbodBoilerGemPerJaar)/totaalAanbodGemPerJaar;
gemiddeldeCOPtotaal = (sum(sum(COPwarmtepomp))/numel(nonzeros(COPwarmtepomp)));


% Plots met grafiek voor het energie aandeel van elke energiebron (Dijle/boiler/buffervat)

figure
plot(energieVraag(:,1));
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totale warmtevraag Werktuigkunde')
axis([0 8760 0 500])   

figure
plot(energieAanbodDijle(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod Dijle rechtstreeks benut in Werktuigkunde')
axis([0 8760 0 500]) 

figure
plot(COPwarmtepomp(:,1))
xlabel('Tijd [h]')
ylabel('COP')
title('COP warmtepomp')
axis([0 8760 0 8])

figure
plot(energieAanbodBoiler(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod boiler')
axis([0 8760 0 500]) 

figure
plot(energieVraagNaLevering(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Resterende energievraag')
axis([0 8760 0 500])

%% Scenario 4: Energiesysteem gelijkaardig aan systeem in bestaand gebouw Werktuigkunde

gegevens;

% Verbruik
[energieVraag] = verbruik('mechanica','/');

% Aanbod
levensduur = 15;
energieVraagBoiler = zeros(8760,levensduur);
energieAanbodBoiler = zeros(8760,levensduur);
totaalPrijsBrandstofBoiler = 0;
totaalCO2Boiler = 0;

for j = 1:levensduur
    for i = 1:8760 
        energieVraagBoiler(i,j) = (energieVraag(i,j)); 
        [productieProfielBoiler, kostBoiler, kostBrand, CO2Boiler, maxVermogen, minVermogen] = boiler(4, 50, 'gas', energieVraagBoiler(i,j), j); %Boiler kan op deellast draaien
        energieAanbodBoiler(i,j) = productieProfielBoiler;
        energieVraagNaLevering(i,j) = (energieVraag(i,j) - energieAanbodBoiler(i,j));
        totaalPrijsBrandstofBoiler = totaalPrijsBrandstofBoiler + kostBrand;
        totaalCO2Boiler = totaalCO2Boiler + CO2Boiler;
    end
end

% Energie aanbod per techniek
totaalAanbodBoilerGemPerJaar = sum(sum(energieAanbodBoiler))/15;
totaalAanbodGemPerJaar = totaalAanbodBoilerGemPerJaar;
    
% Kostprijs en CO2
gemiddeldeCO2Boiler = CO2Gas/efficientieGasKetel;
penaltyCO2Boiler = CO2Certificaat*gemiddeldeCO2Boiler/1000;

gemiddeldePrijsBoiler = totaalPrijsBrandstofBoiler/numel(nonzeros(energieAanbodBoiler)) + kostBoiler/totaalAanbodBoilerGemPerJaar + penaltyCO2Boiler;
gemiddeldePrijsTotaal = gemiddeldePrijsBoiler;

% Plots met het energie aandeel van elke energiebron (Dijle/boiler/buffervat)

figure
plot(energieVraag(:,1));
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Totale warmtevraag Werktuigkunde')
axis([0 8760 0 500])   

figure
plot(energieAanbodBoiler(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Energieaanbod boiler')
axis([0 8760 0 500]) 

figure
plot(energieVraagNaLevering(:,1))
xlabel('Tijd [h]')
ylabel('Energie [kWh]')
title('Resterende energievraag')
axis([0 8760 0 500])
