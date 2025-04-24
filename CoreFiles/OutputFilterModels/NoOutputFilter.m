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


%%%%%%%%%%%%%%%%%%%%%%%%%%%  NO OUTPUT FILTER    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS                               OUTPUTS
% P_inverter						V_outputfilter
% V_inverter						I_outputfilter
% I_inverter						eta_outputfilter
% eta_inverter						P_outputfilter

flag_outputfilter_exist(chosen_solution) = 0;   % flag used during the graph generation to identify if the component exist or not
							 
eta_outputfilter(chosen_solution, wind_i) = 1;
P_outputfilter(chosen_solution, wind_i) = P_inverter(chosen_solution, wind_i);	                
V_outputfilter(chosen_solution, wind_i) = V_inverter(chosen_solution, wind_i);
I_outputfilter(chosen_solution, wind_i) = I_inverter(chosen_solution, wind_i);
