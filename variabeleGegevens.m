function [kostStookolie,kostGas,kostElek] = variabeleGegevens(jaartal)

%% Kostprijzen hedendaagse technieken
kostStookolie = 0.025; %Nog op te zoeken
kostGas = 0.025; %Kost voor KU Leuven
kostElek = 0.09; %Kost voor KU Leuven[euro/kWh]

kostStookolie = kostStookolie*(1.04^(jaartal-1)); %[euro/kWh]
kostGas = kostGas*(1.034^(jaartal-1)); %[euro/kWh] 
kostElek = kostElek*(1.007^(jaartal-1)); %[euro/kWh] 

end