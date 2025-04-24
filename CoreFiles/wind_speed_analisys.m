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
% for each chosen solution
for chosen_solution=1:count_solutions
	constants;

    % for each wind speed
	for wind_i=1:speed_range_point_special
	flag_diode_inverter_out_range(chosen_solution, wind_i) = 0;
	    
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  WIND TURBINE  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		cd ConfigurationFiles
			eval(configuration_file_name{chosen_solution});
		cd ..
		
		maxwind_chosen(chosen_solution) = maxwind_selected;
		if wind_i > maxwind_chosen(chosen_solution)
			wind_i_temp = maxwind_chosen(chosen_solution);
		else
			wind_i_temp = wind_i;
		end;
		
		P_matrix_speed_analysis(1, chosen_solution, wind_i) = 0;
		eta_matrix(1, chosen_solution, wind_i) = 0.0; 
		
		P_in_speed_analysis(chosen_solution, wind_i) = P_input(chosen_solution, wind_i_temp);                   % Variable to store the input power for speed analisys and chosen solution
		P_matrix_speed_analysis(2, chosen_solution, wind_i) = P_wind(chosen_solution, wind_i_temp) - P_in_speed_analysis(chosen_solution, wind_i_temp); % Variable to store the power losses for speed analisys for each component
		eta_matrix(2, chosen_solution, wind_i) = eta_wind(chosen_solution, wind_i_temp);                                                   % Variable to store the efficiency for speed analisys for each component
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  GEAR  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		P_wind_temp(chosen_solution, wind_i_temp) = P_wind(chosen_solution, wind_i_temp);
		T_wind_temp(chosen_solution, wind_i_temp) = T_wind(chosen_solution, wind_i_temp);
		turbine_omega_wind_temp(chosen_solution, wind_i_temp) = turbine_omega_wind(chosen_solution, wind_i_temp);
		
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
		eta_matrix(9, chosen_solution, wind_i) = eta_control(chosen_solution, wind_i);                                    % Variable to store the efficiency for speed analisys for each component	
		
	end;
	
end;

% TOTAL POWER AND EFFICENCY FOR EACH SOLUTION
% Vector generation
for y_index_count=1:count_solutions
	for wind_index=1:speed_range_point_special
		power_index(y_index_count, wind_index)=P_wind(y_index_count, wind_index);
		eta_index(y_index_count, wind_index)=1;
		for component_count=2:9
			power_index(y_index_count, wind_index) = power_index(y_index_count, wind_index)-P_matrix_speed_analysis(component_count, y_index_count, wind_index);	
			if flag_diode_inverter_out_range(y_index_count, wind_index) == 1
				power_index(y_index_count, wind_index) = 0;
			end;
			if power_index(y_index_count, wind_index) < 0
				power_index(y_index_count, wind_index) = 0;
			end;
			eta_index(y_index_count, wind_index) = eta_index(y_index_count, wind_index) * eta_matrix(component_count, y_index_count, wind_index);
		end;
	end;
end;
% Plotting graphs - Power
figure(1)
col1=hsv(count_solutions);
for y_index_count=1:count_solutions
    name_tmp = strcat('Solution ', int2str(y_index_count));
	plot(squeeze(wind_speed_range(y_index_count, :)), squeeze(power_index(y_index_count, :)), '*-','LineWidth', 2, 'color',col1(y_index_count,:), 'DisplayName',name_tmp);
	hold all;
end;
xtitle = title('Total Power Comparison');
set(xtitle,'Fontsize',15);
xhandle = xlabel('Wind speed [m/s]');
yhandle = ylabel('Output Power [W]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
legend('show');
grid on;

% Saving numbers on file
cd ..
cd TableFiles
fp=fopen('wind_speed_analysis_power.txt','w');
% Names for table
fprintf(fp,'POWER DATA [W] \n');
fprintf(fp,'Wind Speed   ');
for y_index_count=1:count_solutions
	name_tmp1 = strcat('Solution ', int2str(y_index_count));
	fprintf(fp,'%s   ', name_tmp1);
end;
% Printing values
for y_temmmmp=1:speed_range_point_special
	fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
	for y_index_count=1:count_solutions
		fprintf(fp, '%e   ', power_index(y_index_count, y_temmmmp));
	end;
end;
fclose(fp);
cd ..
cd CoreFiles


% Plotting graphs - Efficiency
figure(2)
col2=hsv(count_solutions);
for y_index_count=1:count_solutions
    name_tmp = strcat('Solution ', int2str(y_index_count));
	plot(squeeze(wind_speed_range(y_index_count, :)), squeeze(eta_index(y_index_count, :)), '*-','LineWidth', 2, 'color',col2(y_index_count,:), 'DisplayName',name_tmp);
	hold all;
end;
xtitle = title('Total Efficiency Comparison');
set(xtitle,'Fontsize',15);
xhandle = xlabel('Wind speed [m/s]');
yhandle = ylabel('Efficiency');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
legend('show');
grid on;

% Printing total power on file
cd ..
cd TableFiles
fp=fopen('wind_speed_analysis_efficiency.txt','w');
% Names for table
fprintf(fp,'EFFICIENCY DATA \n');
fprintf(fp,'Wind Speed   ');
for y_index_count=1:count_solutions
	name_tmp1 = strcat('Solution ', int2str(y_index_count));
	fprintf(fp,'%s   ', name_tmp1);
end;
% Printing values
for y_temmmmp=1:speed_range_point_special
	fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
	for y_index_count=1:count_solutions
		fprintf(fp, '%e   ', eta_index(y_index_count, y_temmmmp));
	end;
end;
fclose(fp);
cd ..
cd CoreFiles

%% FOR EACH SOLUTION DETAILED LOSSES 
%for y_index_count=1:count_solutions
%	figure(y_index_count+2)
%	col=hsv(9);
%	%plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(2, y_index_count, :)), '*-','LineWidth', 2, 'color',col(1,:), 'DisplayName','Turbine Losses');
%	%hold all;
%	if (flag_gear_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(3, y_index_count, :)), '*-','LineWidth', 2, 'color',col(2,:), 'DisplayName','Gear Losses');
%		hold all;
%	end;
%	if (flag_generator_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(4, y_index_count, :)), '*-','LineWidth', 2, 'color',col(3,:), 'DisplayName','Generator Losses');
%		hold all;
%	end;
%	if (flag_rectifier_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(5, y_index_count, :)), '*-','LineWidth', 2, 'color',col(4,:), 'DisplayName','Rectifier Losses');
%		hold all;
%	end;
%	if (flag_filterswitching_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(6, y_index_count, :)), '*-','LineWidth', 2, 'color',col(5,:), 'DisplayName','Filter/Switching Losses');
%		hold all;
%	end;
%	if (flag_inverter_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(7, y_index_count, :)), '*-','LineWidth', 2, 'color',col(6,:), 'DisplayName','Inverter Losses');
%		hold all;
%	end;
%	if (flag_outputfilter_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(8, y_index_count, :)), '*-','LineWidth', 2, 'color',col%(7,:), 'DisplayName','Output Filter Losses');
%		hold all;
%	end;
%	if (flag_controlsystem_exist(chosen_solution) == 1)
%		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(P_matrix_speed_analysis(9, y_index_count, :)), '*-','LineWidth', 2, 'color',col(8,:), 'DisplayName','Pitch Control Losses');
%	end;
%	name_tmp_1 = strcat('Solution ', int2str(y_index_count));
%	name_tmp_2 = strcat(name_tmp_1, ': Components power losses');
%	xtitle = title(name_tmp_2);
%       set(xtitle,'Fontsize',15);
%	xhandle = xlabel('Wind speed [m/s]');
%	yhandle = ylabel('Power Losses [W]');
%	set(xhandle,'Fontsize',15);
%	set(yhandle,'Fontsize',15);
%	grid on;
%	legend('show');
%end;

% FOR EACH SOLUTION DETAILED EFFICIENCY 
for y_index_count=1:count_solutions
	%figure(y_index_count+2+count_solutions)
	figure(y_index_count+2)
	col=hsv(9);
	plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(2, y_index_count, :)), '*-','LineWidth', 2, 'color',col(1,:), 'DisplayName','Turbine Efficiency');
	hold all;
	if (flag_gear_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(3, y_index_count, :)), '*-','LineWidth', 2, 'color',col(2,:), 'DisplayName','Gear Efficiency');
		hold all;
	end;
	if (flag_generator_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(4, y_index_count, :)), '*-','LineWidth', 2, 'color',col(3,:), 'DisplayName','Generator Efficiency');
		hold all;
	end;
	if (flag_rectifier_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(5, y_index_count, :)), '*-','LineWidth', 2, 'color',col(4,:), 'DisplayName','Rectifier Efficiency');
		hold all;
	end;
	if (flag_filterswitching_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(6, y_index_count, :)), '*-','LineWidth', 2, 'color',col(5,:), 'DisplayName','Filter/Switching Efficiency');
		hold all;
	end;
	if (flag_inverter_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(7, y_index_count, :)), '*-','LineWidth', 2, 'color',col(6,:), 'DisplayName','Inverter Efficiency');
		hold all;
	end;
	if (flag_outputfilter_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(8, y_index_count, :)), '*-','LineWidth', 2, 'color',col(7,:), 'DisplayName','Output Filter Efficiency');
		hold all;
	end;
	if (flag_controlsystem_exist(chosen_solution) == 1)
		plot(squeeze(wind_speed_range(y_index_count, :)),squeeze(eta_matrix(9, y_index_count, :)), '*-','LineWidth', 2, 'color',col(8,:), 'DisplayName','Pitch Control Efficiency');
	end;
	name_tmp_1 = strcat('Solution ', int2str(y_index_count));
	name_tmp_2 = strcat(name_tmp_1, ': Components efficiency');
	xtitle = title(name_tmp_2);
    set(xtitle,'Fontsize',15);
	xhandle = xlabel('Wind speed [m/s]');
	yhandle = ylabel('Efficiency');
	set(xhandle,'Fontsize',15);
	set(yhandle,'Fontsize',15);
	grid on;
	legend('show');
end;

% Printing efficiency data on file
cd ..
cd TableFiles
fp=fopen('wind_speed_analysis_turbine_efficiency.txt','w');
% Names for table
fprintf(fp,'EFFICIENCY DATA \n');
fprintf(fp,'Wind Speed   ');
for y_index_count=1:count_solutions
	name_tmp1 = strcat('Solution ', int2str(y_index_count));
	fprintf(fp,'%s   ', name_tmp1);
end;
% Printing values
for y_temmmmp=1:speed_range_point_special
	fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
	for y_index_count=1:count_solutions
		fprintf(fp, '%e   ', eta_matrix(2, y_index_count, y_temmmmp));
	end;
end;
fclose(fp);
cd ..
cd CoreFiles

if (flag_gear_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_gear_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(3, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_generator_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_generator_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(4, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_rectifier_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_diode_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(5, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_filterswitching_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_filterswitching_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(6, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_inverter_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_inverter_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(7, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_outputfilter_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_outputfilter_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(8, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;

if (flag_controlsystem_exist(chosen_solution) == 1)
	cd ..
	cd TableFiles
	fp=fopen('wind_speed_analysis_pitchcontrol_efficiency.txt','w');
	% Names for table
	fprintf(fp,'EFFICIENCY DATA \n');
	fprintf(fp,'Wind Speed   ');
	for y_index_count=1:count_solutions
		name_tmp1 = strcat('Solution ', int2str(y_index_count));
		fprintf(fp,'%s   ', name_tmp1);
	end;
	% Printing values
	for y_temmmmp=1:speed_range_point_special
		fprintf(fp, '\n %e   ', wind_speed_range(1, y_temmmmp));
		for y_index_count=1:count_solutions
			fprintf(fp, '%e   ', eta_matrix(3, y_index_count, y_temmmmp));
		end;
	end;
	fclose(fp);
	cd ..
	cd CoreFiles
end;
