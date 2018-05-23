clear all
close all

%% Gegevens
WP = 10800;
onderhoudWP = 400;
levensduurWP = 20;
buffer = 3000;
onderhoudbuffer = 100;
levensduurbuffer = 25;
boiler = 35000;
onderhoudboiler = 300;
levensduurboiler = 15;

%Scenario 2
verbruikDijle = 84710;
kostDijle = 0.0298 - (WP/levensduurWP)/verbruikDijle;
verbruikBuffer = 18410;
kostBuffer = 0.0267 - (buffer/levensduurbuffer)/verbruikBuffer;
verbruikBoiler = 490730;
kostBoiler = 0.0416 - (boiler/levensduurboiler)/verbruikBoiler;
verbruikTotaal = 593850;

verbruikScenario2 = (kostDijle*verbruikDijle + kostBuffer*verbruikBuffer + kostBoiler*verbruikBoiler)/verbruikTotaal


%Scenario 4
verbruikBoiler4 = 593850;
kostBoiler4 =  0.0407 - (boiler/levensduurboiler+onderhoudboiler)/verbruikBoiler4;

verbruikScenario4 = kostBoiler4

%% terugverdientijd

investeringScenario2 = WP + buffer + boiler;
investeringScenario4 = boiler;

totaleKostScenario2 = zeros(2000,1);
totaleKostScenario4 = zeros(2000,1);

totaleKostScenario2(1) = investeringScenario2;
totaleKostScenario4(1) = investeringScenario4;

for i = 2:1:2000
    totaleKostScenario2(i) = totaleKostScenario2(i-1) + verbruikScenario2*5938.5;
    totaleKostScenario4(i) = totaleKostScenario4(i-1) + verbruikScenario4*5938.5;    
end

tijd = 0:0.01:19.99;

plot(tijd,totaleKostScenario2)
hold on
plot(tijd,totaleKostScenario4)
xlabel('Tijd [jaar]')
ylabel('Kost [euro]')
title('Terugverdientijd')
legend('Scenario 2','Scenario 4')

for i = 2:1:2000
    totaleKostScenario2(i) = totaleKostScenario2(i-1) + verbruikScenario2*5938.5;
    totaleKostScenario4(i) = totaleKostScenario4(i-1) + verbruikScenario4*5938.5; 
    if totaleKostScenario2(i) < totaleKostScenario4(i)
        break
    end
end
i