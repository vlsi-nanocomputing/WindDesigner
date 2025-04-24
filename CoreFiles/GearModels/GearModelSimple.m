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


%%%%%%%%%%%%%%%%%%%%%%%%%%%  GEAR LOSSES MODEL    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS                                	OUTPUTS
% P_wind_temp(chosen_solution)               P_gear(chosen_solution)
% 								             eta_gear(chosen_solution)
% turbine_omega_wind_temp(chosen_solution)   omega_gear(chosen_solution)
% T_wind_temp(chosen_solution)               T_gear(chosen_solution) 

flag_gear_exist(chosen_solution) = 1;  % flag used during the graph generation to identify if the component exist or not

omega_gear(chosen_solution, wind_i) = turbine_omega_wind_temp(chosen_solution, wind_i_temp) * gear_ratio;                                 % gear output speed
T_gear(chosen_solution, wind_i) = T_wind_temp(chosen_solution, wind_i_temp) / gear_ratio;                                         		% gear output torque
eta_gear(chosen_solution, wind_i) = gear_efficiency;                                                                            % gear efficiency
delta_P_gear(chosen_solution, wind_i) = gear_stilltorque * omega_gear(chosen_solution, wind_i) + (1-eta_gear(chosen_solution, wind_i))*P_wind_temp(chosen_solution, wind_i_temp);   % gear losses		
P_gear(chosen_solution, wind_i) = P_in_speed_analysis(chosen_solution, wind_i_temp) - delta_P_gear(chosen_solution, wind_i);	                    % gear output power
