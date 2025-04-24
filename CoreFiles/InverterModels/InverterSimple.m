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


%%%%%%%%%%%%%%%%%%%%%%%%%%%  INVERTER SIMPLE MODEL    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Warning !! The modeling of an inverter with MPP in all work condiction is difficult, this simple model %%%%%%%%%
%%% tries to emulate the output characteristic of a commercial inverter, with some "creative" approximation %%%%%%%%
%%% for the points not covered by the characteristic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS                               OUTPUTS
% P_filter_switching				P_inverter
% eta_filter_switching				V_inverter
% V_filter_switching  				I_inverter
% I_filter_switching	            eta_inverter

flag_inverter_exist(chosen_solution) = 1;   % flag used during the graph generation to identify if the component exist or not

P_input_inverter(chosen_solution, wind_i) = V_filter_switching(chosen_solution, wind_i) * I_filter_switching(chosen_solution, wind_i);
P_input_normalized(chosen_solution, wind_i) = P_input_inverter(chosen_solution, wind_i) / INV_P_nom;

if P_input_normalized(chosen_solution, wind_i) <= 0.05
	eta_inverter(chosen_solution, wind_i) = P_input_normalized(chosen_solution, wind_i)*INV_ang_coeff_1;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif (P_input_normalized(chosen_solution, wind_i) > 0.05 && P_input_normalized(chosen_solution, wind_i) <= 0.1)
	eta_inverter(chosen_solution, wind_i) = (I_efficiency - 0.087) + P_input_normalized(chosen_solution, wind_i)*INV_ang_coeff_2;	
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif (P_input_normalized(chosen_solution, wind_i) > 0.1 && P_input_normalized(chosen_solution, wind_i) <= 0.15)
	eta_inverter(chosen_solution, wind_i) = (I_efficiency - 0.047) + P_input_normalized(chosen_solution, wind_i)*INV_ang_coeff_3;	
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif (P_input_normalized(chosen_solution, wind_i) > 0.15 && P_input_normalized(chosen_solution, wind_i) <= 0.25)
	eta_inverter(chosen_solution, wind_i) = (I_efficiency - 0.022) + P_input_normalized(chosen_solution, wind_i)*INV_ang_coeff_4;	
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif (P_input_normalized(chosen_solution, wind_i) > 0.25 && P_input_normalized(chosen_solution, wind_i) <= 0.4)
	eta_inverter(chosen_solution, wind_i) = (I_efficiency - 0.012) + P_input_normalized(chosen_solution, wind_i)*INV_ang_coeff_5;	
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
else 
	eta_inverter(chosen_solution, wind_i) = I_efficiency;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
end;
	
if V_filter_switching(chosen_solution, wind_i) < INV_Vin_min            % out of maximum range
	eta_inverter(chosen_solution, wind_i) = 0;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif V_filter_switching(chosen_solution, wind_i) > INV_Vin_max        % out of maximum range
	eta_inverter(chosen_solution, wind_i) = 0;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif V_filter_switching(chosen_solution, wind_i) < INV_Vin_min_mppt	% out of mppt range
	eta_inverter(chosen_solution, wind_i) = eta_inverter(chosen_solution, wind_i) - 0.04;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif V_filter_switching(chosen_solution, wind_i) > INV_Vin_max_mppt	% out of mppt range
	eta_inverter(chosen_solution, wind_i) = eta_inverter(chosen_solution, wind_i) - 0.04;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif V_filter_switching(chosen_solution, wind_i) < INV_Vin_min_etamax	% out of maximum efficiency range
	eta_inverter(chosen_solution, wind_i) = eta_inverter(chosen_solution, wind_i)-0.02;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
elseif V_filter_switching(chosen_solution, wind_i) > INV_Vin_max_etamax	% out of maximum efficiency range
	eta_inverter(chosen_solution, wind_i) = eta_inverter(chosen_solution, wind_i)-0.02;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
else
	eta_inverter(chosen_solution, wind_i) = I_efficiency;
	if eta_inverter(chosen_solution, wind_i) < 0
		eta_inverter(chosen_solution, wind_i) = 0;
	end;
end;

if eta_inverter(chosen_solution, wind_i) == 0
	P_inverter(chosen_solution, wind_i) = P_filter_switching(chosen_solution, wind_i);	                            % inverter output power
	V_inverter(chosen_solution, wind_i) = 0;
	I_inverter(chosen_solution, wind_i) = 0;
	flag_diode_inverter_out_range(chosen_solution, wind_i) = 1;
else
	P_inverter(chosen_solution, wind_i) = P_filter_switching(chosen_solution, wind_i) * eta_inverter(chosen_solution, wind_i);	                            % inverter output power
	V_inverter(chosen_solution, wind_i) = V_filter_switching(chosen_solution, wind_i);
	I_inverter(chosen_solution, wind_i) = I_filter_switching(chosen_solution, wind_i);
end;
