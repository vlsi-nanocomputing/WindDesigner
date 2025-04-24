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


% for each chosen solution
flag_energy_analisys = 1;
for chosen_solution=1:count_solutions
	constants;

    % for each wind speed
	for wind_i=1:WindSpeedLength
	flag_diode_inverter_out_range(chosen_solution, wind_i) = 0;
	    
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  WIND TURBINE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd ConfigurationFiles
			eval(configuration_file_name{chosen_solution});
		cd ..
		
		maxwind_chosen(chosen_solution) = maxwind_selected;
		if WindSpeedProf(wind_i) > maxwind_chosen(chosen_solution)
			v_wind_i_temp = maxwind_chosen(chosen_solution);
			eta_wind_energy(chosen_solution, wind_i) = eta_wind(chosen_solution, v_wind_i_temp); 
			turbine_omega_wind_rpm_energy(chosen_solution, wind_i) = turbine_omega_wind_rpm(chosen_solution, v_wind_i_temp);
			T_wind_energy(chosen_solution, wind_i) = T_wind(chosen_solution, v_wind_i_temp);
		elseif WindSpeedProf(wind_i) < 1
			v_wind_i_temp = WindSpeedProf(wind_i);
			eta_wind_energy(chosen_solution, wind_i) = 0; 
			turbine_omega_wind_rpm_energy(chosen_solution, wind_i) = 1;
			T_wind_energy(chosen_solution, wind_i) = 0;
		else
			v_wind_i_temp = WindSpeedProf(wind_i);
			eta_wind_energy(chosen_solution, wind_i) = interp1(wind_speed_range(chosen_solution, :),eta_wind(chosen_solution, :),v_wind_i_temp); 
			turbine_omega_wind_rpm_energy(chosen_solution, wind_i) = interp1(wind_speed_range(chosen_solution, :),turbine_omega_wind_rpm(chosen_solution, :),v_wind_i_temp);
			T_wind_energy(chosen_solution, wind_i) = interp1(wind_speed_range(chosen_solution, :),T_wind(chosen_solution, :),v_wind_i_temp);
		end;
		wind_i_temp = wind_i;
		turbine_omega_wind_energy(chosen_solution, wind_i) = turbine_omega_wind_rpm_energy(chosen_solution, wind_i) * pi/30;
		P_input_energy(chosen_solution, wind_i) = turbine_omega_wind_energy(chosen_solution, wind_i) * T_wind_energy(chosen_solution, wind_i);
		if eta_wind_energy(chosen_solution, wind_i) > 0
			P_wind_energy(chosen_solution, wind_i) = P_input_energy(chosen_solution, wind_i) / eta_wind_energy(chosen_solution, wind_i);
		else
			P_wind_energy(chosen_solution, wind_i) = 0;
		end;
		
		P_matrix_speed_analysis(1, chosen_solution, wind_i) = 0;
		eta_speed_matrix(1, chosen_solution, wind_i) = 0.0; 
		P_in_speed_analysis(chosen_solution, wind_i) = P_input_energy(chosen_solution, wind_i);                   % Variable to store the input power for speed analisys and chosen solution
		P_matrix_speed_analysis(2, chosen_solution, wind_i) = P_wind_energy(chosen_solution, wind_i) - P_in_speed_analysis(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_speed_matrix(2, chosen_solution, wind_i) = eta_wind_energy(chosen_solution, wind_i);                                                   % Variable to store the efficiency for speed analisys for each component
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  GEAR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		P_wind_temp(chosen_solution, wind_i_temp) = P_wind_energy(chosen_solution, wind_i_temp);
		T_wind_temp(chosen_solution, wind_i_temp) = T_wind_energy(chosen_solution, wind_i_temp);
		turbine_omega_wind_temp(chosen_solution, wind_i_temp) = turbine_omega_wind_energy(chosen_solution, wind_i_temp);
		
		cd GearModels
			eval(Gear_file_name{chosen_solution});
		cd ..
			
		P_matrix_speed_analysis(3, chosen_solution, wind_i) = P_in_speed_analysis(chosen_solution, wind_i_temp)-P_gear(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(3, chosen_solution, wind_i) = eta_gear(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  GENERATOR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd ElectricGeneratorModels
			eval(ElectricGenerator_file_name{chosen_solution});
		cd ..		
		
		P_matrix_speed_analysis(4, chosen_solution, wind_i) = P_gear(chosen_solution, wind_i) - P_generator(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(4, chosen_solution, wind_i) = eta_generator(chosen_solution, wind_i);   % Variable to store the efficiency for speed analisys for each component		
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  RECTIFIER  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd RectifierModels
			eval(Rectifier_file_name{chosen_solution});
		cd ..
			
		P_matrix_speed_analysis(5, chosen_solution, wind_i) = P_generator(chosen_solution, wind_i)-P_rectifier(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(5, chosen_solution, wind_i) = eta_rectifier(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component	
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  FILTER/SWITCHING  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd FilterSwitchingModels
			eval(FilterSwitching_file_name{chosen_solution});
		cd ..   

		P_matrix_speed_analysis(6, chosen_solution, wind_i) = P_rectifier(chosen_solution, wind_i)-P_filter_switching(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(6, chosen_solution, wind_i) = eta_rectifier(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component	
			
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  INVERTER  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd InverterModels
			eval(Inverter_file_name{chosen_solution});
		cd ..

		P_matrix_speed_analysis(7, chosen_solution, wind_i) = P_filter_switching(chosen_solution, wind_i)-P_inverter(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(7, chosen_solution, wind_i) = eta_inverter(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component	
	
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  OUTPUT FILTER  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd OutputFilterModels
			eval(OutputFilter_file_name{chosen_solution});
		cd ..

		P_matrix_speed_analysis(8, chosen_solution, wind_i) = P_inverter(chosen_solution, wind_i)-P_outputfilter(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(8, chosen_solution, wind_i) = eta_outputfilter(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component	
			
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  CONTROL SYSTEM LOSSES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd ControlSystemModels
			eval(ControlSystem_file_name{chosen_solution});
		cd ..

		P_matrix_speed_analysis(9, chosen_solution, wind_i) = P_outputfilter(chosen_solution, wind_i)-P_control(chosen_solution, wind_i); % Variable to store the power losses for speed analisys for each component
		eta_matrix(9, chosen_solution, wind_i) = eta_control(chosen_solution, wind_i);                                % Variable to store the efficiency for speed analisys for each component	
		
	end;
	
end;

% TOTAL POWER AND EFFICENCY FOR EACH SOLUTION
% Vector generation
for y_index_count=1:count_solutions
	energy_tot(y_index_count) = 0;
	for wind_index=1:WindSpeedLength
		power_index(y_index_count, wind_index)=P_wind_energy(y_index_count, wind_index);
		for component_count=2:9
			power_index(y_index_count, wind_index) = power_index(y_index_count, wind_index)-P_matrix_speed_analysis(component_count, y_index_count, wind_index);	
			if flag_diode_inverter_out_range(y_index_count, wind_index) == 1
				power_index(y_index_count, wind_index) = 0;
			end;
			if (power_index(y_index_count, wind_index)<0)
				power_index(y_index_count, wind_index) = 0;
			end;
		end;
		energy_index(y_index_count, wind_index) = power_index(y_index_count, wind_index) * hour_percent  * 1e-3; 
		energy_tot(y_index_count) = energy_tot(y_index_count) + energy_index(y_index_count, wind_index);
	end;
end;

% Plotting graphs - Total Energy
figure(1)
col2=hsv(count_solutions);
x_ax_temp = linspace(1,count_solutions,count_solutions);
for x_row=1:count_solutions
	matrix_temp(1, x_row) = energy_tot(x_row);
end;
bar(x_ax_temp, matrix_temp(:,:));
xtitle = title('Energy total production comparison');
set(xtitle,'Fontsize',15);
xhandle = xlabel('Solutions');
yhandle = ylabel('Energy [kWh]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
hold off;

cd ..
cd TableFiles
fp=fopen('average_analysis_energy.txt','w');
% Names for table
fprintf(fp,'ENERGY DATA (kWh) \n');
for y_index_count=1:count_solutions
	name_tmp1 = strcat('Solution ', int2str(y_index_count));
	fprintf(fp,'%s   ', name_tmp1);
end;
% Printing values
fprintf(fp, '\n');
for y_index_count=1:count_solutions
	fprintf(fp, '%e   ', energy_tot(y_index_count));
end;
fclose(fp);
cd ..
cd CoreFiles


% Plotting graphs - Wind Distribution
figure(2)
plot(WindSpeedSpeed, WindSpeedPercentage, '-*b');
xtitle = title('Wind Profile');
set(xtitle,'Fontsize',15);
yhandle = ylabel('Percentage [/1000]');
xhandle = xlabel('Wind speed [m/s]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
