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


%%%%%%%%%%%%%%%%%%%%%%%%%%%  RECTIFIER LOSSES MODEL    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS                           OUTPUTS
% P_generator                      P_rectifier
% eta_generator					   eta_rectifier
% V_generator					   V_rectifier
% I_generator					   I_rectifier

flag_rectifier_exist(chosen_solution) = 1;   % flag used during the graph generation to identify if the component exist or not

if V_generator(chosen_solution, wind_i) < DIODE_Vin_min
	eta_rectifier(chosen_solution, wind_i) = 0;
elseif V_generator(chosen_solution, wind_i) > DIODE_Vin_max
	eta_rectifier(chosen_solution, wind_i) = 0;
else	
	eta_rectifier(chosen_solution, wind_i) = DIODE_efficiency;  
end;

if eta_rectifier(chosen_solution, wind_i) == 0  
	P_rectifier(chosen_solution, wind_i) = P_generator(chosen_solution, wind_i);	% rectifier output power
	V_rectifier(chosen_solution, wind_i) = 0;
	I_rectifier(chosen_solution, wind_i) = 0;
	flag_diode_inverter_out_range(chosen_solution, wind_i) = 1;
else
	P_rectifier(chosen_solution, wind_i) = P_generator(chosen_solution, wind_i) * eta_rectifier(chosen_solution, wind_i);	% rectifier output power
	V_rectifier(chosen_solution, wind_i) = V_generator(chosen_solution, wind_i) * 1.5;
	I_rectifier(chosen_solution, wind_i) = I_generator(chosen_solution, wind_i) / 1.5;
end;
	
