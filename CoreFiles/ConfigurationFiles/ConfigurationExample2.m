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


%%%%%%%%       Gear                                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gear_ratio = 1;             					% gear speed ratio
gear_efficiency = 0.98;     					% gear efficiency
gear_stilltorque = 0.01;   				    	% gear standstill torque [Nm]

%%%%%%%%       Permanent magnets synchronous generator        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_out   =  50;          						% Output frequency [Hz]
PM_p       = 8      ;      						% number of magnetic couple of poles
PM_ng_N    = (freq_out * 60)/PM_p;      		% rated angular speed [rpm]
PM_PG_N    = 6000   ;                           % rated output power  [W]
PM_TG_N    = PM_PG_N /(PM_ng_N * pi/30);		% rated nominal torque [Nm]
PM_Pad_nom = 0      ;          					% additional losses [W]
PM_V_N     = 400    ;          					% rated output voltage [V]
PM_Ia_N    = PM_PG_N/PM_V_N;					% rated nominal current [A]
PM_Ra_N    = 1.24   ;          					% stator resistance [ohm]
PM_La_N    = 0.0048 ;      	   					% stator inductance [henry]
PM_E0_N    = PM_V_N + PM_Ra_N * PM_Ia_N;        % rated open circuit voltage [V]
PM_R_out   = PM_V_N/PM_Ia_N;   					% rated output resistance
PM_R_out   = PM_V_N/PM_Ia_N;   					% rated output resistance
PM_torque_tollerace = 0.01;                     % tollerance on the iterative calculation of the torque

PM_tu_n_pu  = 0.00407;   						% friction and windage torque at rated speed per unit
PM_tu_ss_pu = 0.00155;   						% standstill torque per unit

PM_K_core1 = 0.01;								% first constant for core losses
PM_K_core2 = 0.015; 							% second constant for core losses
PM_E0_N_ng = PM_E0_N / ((PM_p*PM_ng_N)/60); 	% K*N*flux

%%%%%%%%       Other generator models        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Remember to rename the variable according to the names used in the model itself

%%%%%%%%       Rectifier                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DIODE_Vin_min = 0;								% Diode minimum input voltage [V]
DIODE_Vin_max = 410;							% Diode minimum input voltage [V]
DIODE_Vin_min_etamax = 40;						% Diode minimum input voltage [V]
DIODE_Vin_max_etamax = 410;						% Diode minimum input voltage [V]
DIODE_efficiency = 0.994;                       % Diode efficiency

%%%%%%%%       Inverter                                     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INV_Vin_min = 50;          					    % Inverter maximum accepted input voltage [V]
INV_Vin_max = 610;          					% Inverter maximum accepted input voltage [V]
INV_Vin_min_mppt = 50;                          % Inverter minimum voltage for MPPT [V]
INV_Vin_max_mppt = 580;                         % Inverter maximum voltage for MPPT [V]
INV_Vin_min_etamax = 200;                       % Inverter minimum voltage for maximum efficiency [V]
INV_Vin_max_etamax = 530;                       % Inverter maximum voltage for maximum efficiency [V]
I_efficiency = 0.967;        					% Inverter efficiency
INV_P_nom = 6000;								% Inverter nominal power [W]
INV_ang_coeff_1 = (0.88)/(0.05);				% Inverter angular coefficient of the first part of the inverter efficiency curve
INV_ang_coeff_2 = (0.04)/(0.05);				% Inverter angular coefficient of the second part of the inverter efficiency curve
INV_ang_coeff_3 = (0.025)/(0.05);				% Inverter angular coefficient of the third part of the inverter efficiency curve
INV_ang_coeff_4 = (0.01)/(0.1);				    % Inverter angular coefficient of the forth part of the inverter efficiency curve
INV_ang_coeff_5 = (0.01)/(0.15);				% Inverter angular coefficient of the forth part of the inverter efficiency curve




% TORQUE-SPEED CHARACTERISTIC

wind_speed_range(chosen_solution, :) = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];   % [m/s] 
% Maximum wind speed selected, can be lower than the maximum wind speed available to limit the analysis to a specific wind speed value
maxwind_selected = 13;    % [m/s]  MUST be an integer
% Turbine mechanical efficiency
eta_wind(chosen_solution, :) = [0 0 0 0 0.33 0.38 0.46 0.53 0.53 0.53 0.53 0.53 0.53 0.53 0.53];
% Turbine rotation speed [rpm]
turbine_omega_wind_rpm(chosen_solution, :) = [1 1 1 127 159 191 223 255 286 318 350 382 414 446 477];
% Turbine rotation speed [rad/s]
for i=1:speed_range_point_special
	turbine_omega_wind(chosen_solution, i) = turbine_omega_wind_rpm(chosen_solution, i) * pi/30;
end;
% Turbine generated mechanical torque
T_wind(chosen_solution, :) = [0 0 0 10.7 16.7 24.1 32.7 42.8 54.1 66.8 80.9 96.2 113 131 150];
for i=1:speed_range_point_special
	P_input(chosen_solution, i) = turbine_omega_wind(chosen_solution, i) * T_wind(chosen_solution, i);   % Mechanical power generated
	if eta_wind(chosen_solution, i) > 0
		P_wind(chosen_solution, i) = P_input(chosen_solution, i) / eta_wind(chosen_solution, i);            % Kinetic power of wind
	else
		P_wind(chosen_solution, i) = 0;
	end;
end;
