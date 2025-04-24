%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  WIND DESIGNER  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - Author			Marco Vacca 								%
% - Author Affiliation  	Politecnico di Torino, Dipartimento di Elettronica e Telecomunicazioni	%%													%
% - version 1                   23/06/2012  								%
% - version 2			30/10/2013     								%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2012-2013, 2013 Marco Vacca									% 					
%													%
% This file is part of WindDesigner.									%
%													%
% WindDesigner is free software: you can redistribute it and/or modify					%
% it under the terms of the GNU General Public License as published by					%
% the Free Software Foundation, either version 3 of the License, or					%
% (at your option) any later version.									%
%													%
% WindDesigner is distributed in the hope that it will be useful,					%
% but WITHOUT ANY WARRANTY; without even the implied warranty of					%
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the						%
% GNU General Public License for more details.								%
%													%
% You should have received a copy of the GNU General Public License					%
% along with WindDesigner.  If not, see <http://www.gnu.org/licenses/>.					%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%  WIND DISTRIBUTION 1 - Daily Analysis  %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Percentage [/1000] of the corresponding wind speed over the time period considered
WindSpeedPercentage = [30 30 50 65 73 80 79 78 74 65 60 53 44 37 33 25 19 16 14 13 12 10 9 8 6 5 5 5];
% Wind speeds
WindSpeedSpeed =[0.25 0.75 1.25 1.75 2.25 2.75 3.25 3.75 4.25 4.75 5.25 5.75 6.25 6.75 7.25 7.75 8.25 8.75 9.25 9.75 10.25 10.75 11.25 11.75 12.25 12.75 13.5 14.5];  % The minimum and maximum wind speed must be inside the range of the wind speeds reported in the configuration file selected
% Number of points of the wind speed and percentage vectors
WindSpeedPercentageLenght = 28;				 

% Percentage wind speed
base_percentage = 1;
base_percentage_fin = base_percentage + WindSpeedPercentage(1);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(1);
end;

base_percentage = base_percentage + WindSpeedPercentage(1);
base_percentage_fin = base_percentage + WindSpeedPercentage(2);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(2);
end;

base_percentage = base_percentage + WindSpeedPercentage(2);
base_percentage_fin = base_percentage + WindSpeedPercentage(3);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(3);
end;

base_percentage = base_percentage + WindSpeedPercentage(3);
base_percentage_fin = base_percentage + WindSpeedPercentage(4);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(4);
end;

base_percentage = base_percentage + WindSpeedPercentage(4);
base_percentage_fin = base_percentage + WindSpeedPercentage(5);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(5);
end;

base_percentage = base_percentage + WindSpeedPercentage(5);
base_percentage_fin = base_percentage + WindSpeedPercentage(6);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(6);
end;

base_percentage = base_percentage + WindSpeedPercentage(6);
base_percentage_fin = base_percentage + WindSpeedPercentage(7);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(7);
end;

base_percentage = base_percentage + WindSpeedPercentage(7);
base_percentage_fin = base_percentage + WindSpeedPercentage(8);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(8);
end;

base_percentage = base_percentage + WindSpeedPercentage(8);
base_percentage_fin = base_percentage + WindSpeedPercentage(9);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(9);
end;

base_percentage = base_percentage + WindSpeedPercentage(9);
base_percentage_fin = base_percentage + WindSpeedPercentage(10);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(10);
end;

base_percentage = base_percentage + WindSpeedPercentage(10);
base_percentage_fin = base_percentage + WindSpeedPercentage(11);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(11);
end;

base_percentage = base_percentage + WindSpeedPercentage(11);
base_percentage_fin = base_percentage + WindSpeedPercentage(12);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(12);
end;

base_percentage = base_percentage + WindSpeedPercentage(12);
base_percentage_fin = base_percentage + WindSpeedPercentage(13);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(13);
end;

base_percentage = base_percentage + WindSpeedPercentage(13);
base_percentage_fin = base_percentage + WindSpeedPercentage(14);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(14);
end;

base_percentage = base_percentage + WindSpeedPercentage(14);
base_percentage_fin = base_percentage + WindSpeedPercentage(15);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(15);
end;

base_percentage = base_percentage + WindSpeedPercentage(15);
base_percentage_fin = base_percentage + WindSpeedPercentage(16);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(16);
end;

base_percentage = base_percentage + WindSpeedPercentage(16);
base_percentage_fin = base_percentage + WindSpeedPercentage(17);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(17);
end;

base_percentage = base_percentage + WindSpeedPercentage(17);
base_percentage_fin = base_percentage + WindSpeedPercentage(18);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(18);
end;

base_percentage = base_percentage + WindSpeedPercentage(18);
base_percentage_fin = base_percentage + WindSpeedPercentage(19);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(19);
end;

base_percentage = base_percentage + WindSpeedPercentage(19);
base_percentage_fin = base_percentage + WindSpeedPercentage(20);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(20);
end;

base_percentage = base_percentage + WindSpeedPercentage(20);
base_percentage_fin = base_percentage + WindSpeedPercentage(21);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(21);
end;

base_percentage = base_percentage + WindSpeedPercentage(21);
base_percentage_fin = base_percentage + WindSpeedPercentage(22);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(22);
end;

base_percentage = base_percentage + WindSpeedPercentage(22);
base_percentage_fin = base_percentage + WindSpeedPercentage(23);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(23);
end;

base_percentage = base_percentage + WindSpeedPercentage(23);
base_percentage_fin = base_percentage + WindSpeedPercentage(24);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(24);
end;

base_percentage = base_percentage + WindSpeedPercentage(24);
base_percentage_fin = base_percentage + WindSpeedPercentage(25);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(25);
end;

base_percentage = base_percentage + WindSpeedPercentage(25);
base_percentage_fin = base_percentage + WindSpeedPercentage(26);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(26);
end;

base_percentage = base_percentage + WindSpeedPercentage(26);
base_percentage_fin = base_percentage + WindSpeedPercentage(27);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(27);
end;

base_percentage = base_percentage + WindSpeedPercentage(27);
base_percentage_fin = base_percentage + WindSpeedPercentage(28);
for i=base_percentage:base_percentage_fin
	WindSpeedProf(i) = WindSpeedSpeed(28);
end;
base_percentage = base_percentage + WindSpeedPercentage(28);
% If the number of points (WindSpeedPercentageLenght) is increased or reduced the calculation of base_percentage must be increased or reduced accordingly
				
WindSpeedLength = base_percentage;  % Number of speed vector points
WindTimeLenght = 24;   % Lenght of the time period considered[hours]

% Calculation of the time duration of each point
hour_percent = WindTimeLenght/WindSpeedLength;						  
