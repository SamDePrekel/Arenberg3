function [vermogen, COP, investeringKost1Jaar] = warmtepomp(type, inlaatTemperatuur, uitlaatTemperatuur, typeSysteem)
% Deze functie beschouwd de karakteristieken van verschillende type warmtepompen
% Input typeSysteem is "Open" ofwel "Gesloten"
% Open systeem: één scheidingswarmtewisselaar om verdamper (plaatwarmtewisselaar) te beschermen van vervuild water
% Gesloten systeem: scheidingswarmtewisselaar ligt in Dijle (schatting: inlaattempeatuur is ongeveer 2°C lager)

vermogen = 0;
COP = 0;

%% Warmtepomp Vitocal 300G BWC 301.B13
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 11)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 12.942*exp(0.0274*inlaatTemperatuur);  %12.942*exp(0.0274*inlaatTemperatuur);
                COP = 4.9857*exp(0.0252*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 11.955*exp(0.0239*inlaatTemperatuur);
                COP = 2.9515*exp(0.0223*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
            if(uitlaatTemperatuur == 35)
                vermogen = 12.942*exp(0.0274*(inlaatTemperatuur-2));
                COP = 4.9857*exp(0.0252*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 11.955*exp(0.0239*(inlaatTemperatuur-2));
                COP = 2.9515*exp(0.0223*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 8600; %Kostprijs: 15000 (subsidie in rekening gebracht)
onderhoud = 350;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G BWC 301.B17
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 1)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 17.318*exp(0.0265*inlaatTemperatuur);
                COP = 4.7763*exp(0.0249*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 16.089*exp(0.0239*inlaatTemperatuur);
                COP = 2.9001*exp(0.020*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
            if(uitlaatTemperatuur == 35)
                vermogen = 17.404*exp(0.0374*(inlaatTemperatuur-2));
                COP = 4.7986*exp(0.0351*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 16.138*exp(0.0340*(inlaatTemperatuur-2));
                COP = 2.9007*exp(0.0290*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 10800; %Kostprijs: 18000 (subsidie in rekening gebracht)
onderhoud = 400;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G BW 301-A021
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 2)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 21.388*exp(0.028*inlaatTemperatuur); %21.388*exp(0.0272*inlaatTemperatuur);
                COP = 4.7107*exp(0.027*inlaatTemperatuur); %4.7107*exp(0.0257*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 55)
                vermogen = 19.332*exp(0.026*inlaatTemperatuur); %19.332*exp(0.0255*inlaatTemperatuur);
                COP = 2.8358*exp(0.027*inlaatTemperatuur); %2.8358*exp(0.0254*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
             if(uitlaatTemperatuur == 35)
                vermogen = 21.388*exp(0.0272*(inlaatTemperatuur-2));
                COP = 4.7107*exp(0.0257*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 19.332*exp(0.0255*(inlaatTemperatuur-2));
                COP = 2.8358*exp(0.0254*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 14400; %Kostprijs: 24000 (subsidie in rekening gebracht)
onderhoud = 500;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G BW 301-A045
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 3)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 43.384*exp(0.0287*inlaatTemperatuur);
                COP = 4.4852*exp(0.0238*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 39.122*exp(0.0224*inlaatTemperatuur);
                COP = 2.7215*exp(0.0229*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
             if(uitlaatTemperatuur == 35)
                vermogen = 43.384*exp(0.0287*(inlaatTemperatuur-2));
                COP = 4.4852*exp(0.0238*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 39.122*exp(0.0224*(inlaatTemperatuur-2));
                COP = 2.7215*exp(0.0229*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 18000; %Kostprijs: 30000 (subsidie in rekening gebracht) 
onderhoud = 600;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G Pro BW 302-B090
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 4)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 88.601*exp(0.0293*inlaatTemperatuur);
                COP = 4.8296*exp(0.0259*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 80.351*exp(0.0257*inlaatTemperatuur);
                COP = 2.7837*exp(0.0246*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
            if(uitlaatTemperatuur == 35)
                vermogen= 88.601*exp(0.0293*(inlaatTemperatuur-2));
                COP = 4.8296*exp(0.0259*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 80.351*exp(0.0257*(inlaatTemperatuur-2));
                COP = 2.7837*exp(0.0246*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 28200; %Kostprijs: 47000 (subsidie in rekening gebracht)
onderhoud = 800;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G Pro BW 302-B120
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 5)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 115.41*exp(0.029*inlaatTemperatuur);
                COP = 4.715*exp(0.0248*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 103.87*exp(0.0256*inlaatTemperatuur);
                COP = 2.8712*exp(0.0214*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
             if(uitlaatTemperatuur == 35)
                vermogen = 115.41*exp(0.029*(inlaatTemperatuur-2));
                COP = 4.715*exp(0.0248*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 103.87*exp(0.0256*(inlaatTemperatuur-2));
                COP = 2.8712*exp(0.0214*(inlaatTemperatuur-2));
             end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 36000; %Kostprijs: 60000 (subsidie in rekening gebracht)
onderhoud = 1200;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 300G Pro BW 302-B250
% Maximum uitlaattemperatuur is 55°C bij een lage inlaattemperatuur, maar kleinere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 6)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 7)
            if(uitlaatTemperatuur == 35)
                vermogen = 237.1*exp(0.0216*inlaatTemperatuur);
                COP = 4.7604*exp(0.0173*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 211.83*exp(0.0197*inlaatTemperatuur);
                COP = 2.7668*exp(0.0185*inlaatTemperatuur);
            end
        else 
            vermogen = 0;
            COP = 0;
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)
            if(uitlaatTemperatuur == 35)
                vermogen = 237.1*exp(0.0216*(inlaatTemperatuur-2));
                COP = 4.7604*exp(0.0173*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 211.83*exp(0.0197*(inlaatTemperatuur-2));
                COP = 2.7668*exp(0.0185*(inlaatTemperatuur-2));
            end
        else 
            vermogen = 0;
            COP = 0;
        end    
    end

% Berekening kost
investering = 60000; %Kostprijs: 100000 (subsidie in rekening gebracht)
onderhoud = 1600;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 350G Pro 352-A034
% Maximum uitlaattemperatuur is 73°C bij een lage inlaattemperatuur, maar hogere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 7)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 8)  
            if(uitlaatTemperatuur == 35)
                vermogen = 33.915*exp(0.0379*inlaatTemperatuur);
                COP = 4.3047*exp(0.0267*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 26.819*exp(0.042*inlaatTemperatuur);
                COP = 2.981*exp(0.0206*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 73)
                vermogen = 19.911*exp(0.0455*inlaatTemperatuur);
                COP = 2.1396*exp(0.0185*inlaatTemperatuur);
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)  
            if(uitlaatTemperatuur == 35)
                vermogen = 33.915*exp(0.0379*(inlaatTemperatuur-2));
                COP = 4.3047*exp(0.0267*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 26.819*exp(0.042*(inlaatTemperatuur-2));
                COP = 2.981*exp(0.0206*(inlaatTemperatuur-2));
            elseif(uitlaatTemperatuur == 73)
                vermogen = 19.911*exp(0.0455*(inlaatTemperatuur-2));
                COP = 2.1396*exp(0.0185*(inlaatTemperatuur-2));
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    end    

% Berekening kost
investering = 9000; %Kostprijs: 15000 (subsidie in rekening gebracht)
onderhoud = 800;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar 
end

%% Warmtepomp Vitocal 350G Pro 352-A056
% Maximum uitlaattemperatuur is 73°C bij een lage inlaattemperatuur, maar hogere investeringskost
% Kan zowel aangesloten worden op een open als een gesloten systeem.

if(type == 8)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 8) 
            if(uitlaatTemperatuur == 35)
                vermogen = 55.787*exp(0.0379*inlaatTemperatuur);
                COP = 4.3303*exp(0.0263*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 55)
                vermogen = 55.787*exp(0.0379*inlaatTemperatuur);
                COP = 2.9903*exp(0.02*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 73)
                vermogen = 33.744*exp(0.0447*inlaatTemperatuur);
                COP = 2.2027*exp(0.0168*inlaatTemperatuur);
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3) 
            if(uitlaatTemperatuur == 35)
                vermogen = 55.787*exp(0.0379*(inlaatTemperatuur-2));
                COP = 4.3303*exp(0.0263*(inlaatTemperatuur-2));
            elseif(uitlaatTemperatuur == 55)
                vermogen = 55.787*exp(0.0379*(inlaatTemperatuur-2));
                COP = 2.9903*exp(0.02*(inlaatTemperatuur-2));
            elseif(uitlaatTemperatuur == 73)
                vermogen = 33.744*exp(0.0447*(inlaatTemperatuur-2));
                COP = 2.2027*exp(0.0168*(inlaatTemperatuur-2));
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    end    


% Berekening kost
investering = 42000; %Kostprijs: 70000 (subsidie in rekening gebracht)
onderhoud = 1000;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 350G Pro 352-A076
% Maximum uitlaattemperatuur is 73°C bij een lage inlaattemperatuur, maar hogere investeringskost

if(type == 9)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 8)  
            if(uitlaatTemperatuur == 35)
                vermogen = 75.367*exp(0.0372*inlaatTemperatuur);
                COP = 4.3817*exp(0.026*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 61.652*exp(0.0391*inlaatTemperatuur);
                COP = 3.0107*exp(0.0206*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 73)
                vermogen = 47.079*exp(0.0427*inlaatTemperatuur);
                COP = 2.1831*exp(0.0181*inlaatTemperatuur);
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)  
            if(uitlaatTemperatuur == 35)
                vermogen = 75.367*exp(0.0372*(inlaatTemperatuur-2));
                COP = 4.3817*exp(0.026*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 61.652*exp(0.0391*(inlaatTemperatuur-2));
                COP = 3.0107*exp(0.0206*(inlaatTemperatuur-2));
            elseif(uitlaatTemperatuur == 73)
                vermogen = 47.079*exp(0.0427*(inlaatTemperatuur-2));
                COP = 2.1831*exp(0.0181*(inlaatTemperatuur-2));
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    end         

% Berekening kost
investering = 48000; %Kostprijs: 80000 (subsidie in rekening gebracht)
onderhoud = 1150;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end

%% Warmtepomp Vitocal 350G Pro 352-A114
% Maximum uitlaattemperatuur is 73°C bij een lage inlaattemperatuur, maar hogere investeringskost

if(type == 10)
% Vermogen en COP in functie van inlaat- en uitlaattemperatuur voor open en gesloten systeem 
    if strcmp(typeSysteem,'open')
        if(inlaatTemperatuur > 8)  
            if(uitlaatTemperatuur == 35)
                vermogen = 111.49*exp(0.0365*inlaatTemperatuur);
                COP = 4.3731*exp(0.025*inlaatTemperatuur); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 89.597*exp(0.0405*inlaatTemperatuur);
                COP = 3.0114*exp(0.0197*inlaatTemperatuur);
            elseif(uitlaatTemperatuur == 73)
                vermogen = 67.681*exp(0.0443*inlaatTemperatuur);
                COP = 2.196*exp(0.017*inlaatTemperatuur);
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    elseif strcmp(typeSysteem,'gesloten')
        if(inlaatTemperatuur > 3)  
            if(uitlaatTemperatuur == 35)
                vermogen = 111.49*exp(0.0365*(inlaatTemperatuur-2));
                COP = 4.3731*exp(0.025*(inlaatTemperatuur-2)); 
            elseif(uitlaatTemperatuur == 55)
                vermogen = 89.597*exp(0.0405*(inlaatTemperatuur-2));
                COP = 3.0114*exp(0.0197*(inlaatTemperatuur-2));
            elseif(uitlaatTemperatuur == 73)
                vermogen = 67.681*exp(0.0443*(inlaatTemperatuur-2));
                COP = 2.196*exp(0.017*(inlaatTemperatuur-2));
            end
        else
            vermogen = 0;
            COP = 0; 
        end
    end      

% Berekening kost
investering = 60000; %Kostprijs: 100000 (subsidie in rekening gebracht)
onderhoud = 1300;
levensduur = 20; 
investeringKost1Jaar = investering/levensduur + onderhoud; %Investeringskost per jaar
end


end
