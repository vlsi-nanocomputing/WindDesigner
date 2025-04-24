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


flag_energy_analisys = 0;
for chosen_solution=1:count_generators 											% for each solution

	x_counter = 0;
	wind_i = 0;
	for surface_speed=speed_min(4, count_generators):speed_step(4, count_generators):speed_max(4, count_generators) % for each power value
		x_counter = x_counter + 1;
		x_speed(chosen_solution, x_counter) = surface_speed * pi/30;				% x axis building
		for surface_torque=torque_min(4, count_generators):torque_step(4, count_generators):torque_max(4, count_generators)	% for each speed value
		
			cd ConfigurationFiles
				eval(configuration_file_name{chosen_solution});
			cd ..
		
			wind_i = wind_i + 1;
			wind_i_temp = wind_i;
			y_torque(chosen_solution, wind_i) = surface_torque;							% y axis building
			
			P_wind(chosen_solution, wind_i) = y_torque(chosen_solution, wind_i) * x_speed(chosen_solution, x_counter);
			P_gear(chosen_solution, wind_i) = P_wind(chosen_solution, wind_i);
			surface_matrix_input_power(wind_i,x_counter) = P_wind(chosen_solution, wind_i);
			
			
			omega_gear(chosen_solution, wind_i) =  x_speed(chosen_solution, x_counter);
			T_gear(chosen_solution, wind_i) = y_torque(chosen_solution, wind_i);
			
			cd ElectricGeneratorModels
				eval(ElectricGenerator_file_name{chosen_solution});
			cd ..
				
			Delta_P_mech(chosen_solution, wind_i) = P_losses_mechanical(chosen_solution, wind_i);
			Delta_P_copper(chosen_solution, wind_i) = P_losses_copper(chosen_solution, wind_i);
			Delta_P_core(chosen_solution, wind_i) = P_losses_core(chosen_solution, wind_i);
			Delta_P_add(chosen_solution, wind_i) = P_losses_additional(chosen_solution, wind_i);
			Delta_P_exch(chosen_solution, wind_i) = P_losses_excitation(chosen_solution, wind_i);
			Total_torque_losses(chosen_solution, wind_i) = T_losses_generator(chosen_solution, wind_i);
			Output_voltage(chosen_solution, wind_i) = V_generator(chosen_solution, wind_i);
			Output_power(chosen_solution, wind_i) = P_generator(chosen_solution, wind_i);
			Gen_efficiency(chosen_solution, wind_i) = eta_generator(chosen_solution, wind_i);		
			surface_matrix_efficiency(wind_i,x_counter) = Gen_efficiency(chosen_solution, wind_i);
				
		end;
	end;
	
	figure(chosen_solution)
	surf(squeeze(x_speed(chosen_solution, :).*30/pi),squeeze(y_torque(chosen_solution, :)),surface_matrix_efficiency, surface_matrix_input_power);
	name_tmp_1 = strcat('Solution ', int2str(chosen_solution));
	shading interp;
	xtitle = title(name_tmp_1);
	set(xtitle,'Fontsize',15);
	xhandle = xlabel('Angular speed [rpm]');
	yhandle = ylabel('Torque [Nm]');
	zhandle = zlabel('Efficiency');
	set(xhandle,'Fontsize',15);
	set(yhandle,'Fontsize',15);
	set(zhandle,'Fontsize',15);
	xcolorbar = colorbar;
	xcolorbartitle = title(xcolorbar, 'Input Power [W]');
	set(xcolorbartitle,'Fontsize',13);
	grid on;
	
end;
			
			
