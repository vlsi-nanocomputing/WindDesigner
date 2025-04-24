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

clear all;
close all;
clc;

count_solutions = 0;           % variable to count the number of solutions to be compared
count_generators = 0;          % variable to count the number of generators to be compared
chosen_solution = 0;	       % variable to work on one of the solutions loaded
choose_generator = 0;          % variable to select used to select the type of generator
choose_network = 0;            % variable to select network connection or not
choose_control = 0;            % variable to select the control type
choose_gear = 0;               % variable to set the gear or not
choose_filter_switching = 0;   % variable to set filter/switching
choose_rectifier = 0;          % variable to set the rectifier or not
choose_inverter = 0;           % variable to set inverter or not
choose_pitch_control = 0;      % variable to set pitch control or not
choose_output_filter = 0;      % variable to set
choose_display = 0;            % variable to select the desiderd output
choose_day_average = 0;        % variable to select input files in the day average calculation
choose_month_average = 0;      % variable to select input files in the month average calculation
choose_year_average = 0;       % variable to select input files in the year average calculation
choose_average_type = 0;       % variable to select average analisys
choose_generator_analysis = 0; % variable to select the desired options in the generator analisys
choose_generator_spec = 0;     % variable to select generator in its special analisys
choose_generator_profile = 0;  % variable to select torque-speed profile in the generator special analisys
choose_wind_gen_comparison = 0;% variable to set the submenu in the Wind generator structure definment
choose_generator_an_sub = 0;   % variable to select the sub menu in the first option of the generator analisys
choose_generator_su_sub = 0;   % variable to select the sub menu in the second option of the generator analisys
choose = 0;

% choice_matrix(:, 1)          % Network connection
% choice_matrix(:, 2)          % Control type
% choice_matrix(:, 3)          % "Gear or not gear" this is the problem
% choice_matrix(:, 4)          % Generator
% choice_matrix(:, 5)          % Rectifier
% choice_matrix(:, 6)          % Filter/Switching regulator
% choice_matrix(:, 7)          % Inverter
% choice_matrix(:, 8)          % Output filter
% choice_matrix(:, 9)          % Pitch control system

while (choose < 5)
choose = menu('WIND DESIGNER', 'Wind Generators Comparison', 'Electrical Generator Analisys', 'Change System Constants', 'Reset variables', 'Quit');

%[4] Reset values and start a new analisys
	if (choose == 4)
		clearvars -except choose
		close all;
		count_solutions = 0;           
		count_generators = 0;          
		chosen_solution = 0;	       
		choose_generator = 0;          
		choose_network = 0;            
		choose_control = 0;            
		choose_gear = 0;               
		choose_filter_switching = 0;   
		choose_rectifier = 0;          
		choose_inverter = 0;           
		choose_pitch_control = 0;      
		choose_output_filter = 0;      
		choose_display = 0;            
		choose_day_average = 0;        
		choose_month_average = 0;      
		choose_year_average = 0;       
		choose_average_type = 0;       
		choose_generator_analysis = 0; 
		choose_generator_spec = 0;     
		choose_generator_profile = 0;  
		choose_wind_gen_comparison = 0;
		choose_generator_an_sub = 0;   
		choose_generator_su_sub = 0;   
		choose = 0;
	end;
		
%[1] Wind Generator Comparison
    if (choose == 1)
		choose_wind_gen_comparison = 0;
		while (choose_wind_gen_comparison < 3) 
		choose_wind_gen_comparison = menu('Wind Generators Comparison', 'Define a wind generator structure (can be selected many times)', 'Display results', 'Return Back');
		
			% Wind generator structure definition
			if (choose_wind_gen_comparison == 1)
				count_solutions = count_solutions + 1;
				% Network choice
				choose_network = 0; 
					choose_network = menu('Choose how the generator will be used', 'Network connected', 'Isolated');
					if (choose_network == 1)
						choice_matrix(count_solutions, 1) = 1;
					end;
					if (choose_network == 2)
						choice_matrix(count_solutions, 1) = 2;
					end;
		
				% Configuration choice
				choose_control = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd ConfigurationFiles
					configuration_directory = dir(fullfile('*.m'));
					configuration_number_of_files = length(configuration_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_configuration_files = 1:configuration_number_of_files
						configuration_directory_file = configuration_directory(temp_configuration_files).name;
						[pathstr,name,ext] = fileparts(configuration_directory_file);
						configuration_directory_final{temp_configuration_files} = name;
					end
				
				choose_control = menu('Choose configuration file (Torque-Speed characteristic and components parameters)', configuration_directory_final);
				configuration_file_name{count_solutions} = configuration_directory_final{choose_control};
		
				% Gear choice
				choose_gear = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd GearModels
					Gear_directory = dir(fullfile('*.m'));
					Gear_number_of_files = length(Gear_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_Gear_files = 1:Gear_number_of_files
						Gear_directory_file = Gear_directory(temp_Gear_files).name;
						[pathstr,name,ext] = fileparts(Gear_directory_file);
						Gear_directory_final{temp_Gear_files} = name;
					end
				
				choose_gear = menu('Choose gear model', Gear_directory_final);
				Gear_file_name{count_solutions} = Gear_directory_final{choose_gear};
	
				% Electric generator choice
				choose_generator = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd ElectricGeneratorModels
					ElectricGenerator_directory = dir(fullfile('*.m'));
					ElectricGenerator_number_of_files = length(ElectricGenerator_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_ElectricGenerator_files = 1:ElectricGenerator_number_of_files
						ElectricGenerator_directory_file = ElectricGenerator_directory(temp_ElectricGenerator_files).name;
						[pathstr,name,ext] = fileparts(ElectricGenerator_directory_file);
						ElectricGenerator_directory_final{temp_ElectricGenerator_files} = name;
					end
				
				choose_generator = menu('Choose generator model', ElectricGenerator_directory_final);
				ElectricGenerator_file_name{count_solutions} = ElectricGenerator_directory_final{choose_generator};
				
				% Rectifier
				choose_rectifier = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd RectifierModels
					Rectifier_directory = dir(fullfile('*.m'));
					Rectifier_number_of_files = length(Rectifier_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_Rectifier_files = 1:Rectifier_number_of_files
						Rectifier_directory_file = Rectifier_directory(temp_Rectifier_files).name;
						[pathstr,name,ext] = fileparts(Rectifier_directory_file);
						Rectifier_directory_final{temp_Rectifier_files} = name;
					end
				
				choose_rectifier = menu('Choose rectifier model', Rectifier_directory_final);
				Rectifier_file_name{count_solutions} = Rectifier_directory_final{choose_rectifier};				
		
				% Filter or Switching between rectifier and inverter
				choose_filter_switching = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd FilterSwitchingModels
					FilterSwitching_directory = dir(fullfile('*.m'));
					FilterSwitching_number_of_files = length(FilterSwitching_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_FilterSwitching_files = 1:FilterSwitching_number_of_files
						FilterSwitching_directory_file = FilterSwitching_directory(temp_FilterSwitching_files).name;
						[pathstr,name,ext] = fileparts(FilterSwitching_directory_file);
						FilterSwitching_directory_final{temp_FilterSwitching_files} = name;
					end
				
				choose_filter_switching = menu('Choose filter or switching regulator model', FilterSwitching_directory_final);
				FilterSwitching_file_name{count_solutions} = FilterSwitching_directory_final{choose_filter_switching};				
		
				% Inverter
				choose_inverter = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd InverterModels
					Inverter_directory = dir(fullfile('*.m'));
					Inverter_number_of_files = length(Inverter_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_Inverter_files = 1:Inverter_number_of_files
						Inverter_directory_file = Inverter_directory(temp_Inverter_files).name;
						[pathstr,name,ext] = fileparts(Inverter_directory_file);
						Inverter_directory_final{temp_Inverter_files} = name;
					end
				
				choose_inverter = menu('Choose inverter model', Inverter_directory_final);
				Inverter_file_name{count_solutions} = Inverter_directory_final{choose_inverter};	
		
				% Output filter
				choose_output_filter = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd OutputFilterModels
					OutputFilter_directory = dir(fullfile('*.m'));
					OutputFilter_number_of_files = length(OutputFilter_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_OutputFilter_files = 1:OutputFilter_number_of_files
						OutputFilter_directory_file = OutputFilter_directory(temp_OutputFilter_files).name;
						[pathstr,name,ext] = fileparts(OutputFilter_directory_file);
						OutputFilter_directory_final{temp_OutputFilter_files} = name;
					end
				
				choose_output_filter = menu('Choose output filter model', OutputFilter_directory_final);
				OutputFilter_file_name{count_solutions} = OutputFilter_directory_final{choose_output_filter};	
		
				% Control System Losses
				choose_control_system = 0; 
				
					% Get names from directory
					cd CoreFiles
					cd ControlSystemModels
					ControlSystem_directory = dir(fullfile('*.m'));
					ControlSystem_number_of_files = length(ControlSystem_directory);
					cd ..
					cd ..
					% Get only the file name and remove file extension
					for temp_ControlSystem_files = 1:ControlSystem_number_of_files
						ControlSystem_directory_file = ControlSystem_directory(temp_ControlSystem_files).name;
						[pathstr,name,ext] = fileparts(ControlSystem_directory_file);
						ControlSystem_directory_final{temp_ControlSystem_files} = name;
					end
				
				choose_control_system = menu('Choose control system model', ControlSystem_directory_final);
				ControlSystem_file_name{count_solutions} = ControlSystem_directory_final{choose_control_system};
			end;
			
	
			% Display results
			if (choose_wind_gen_comparison == 2)
		
			choose_display = 0;
				while (choose_display < 3)
				choose_display = menu('Display results', 'Wind speed analisys', 'Energy analisys', 'Return back'); 
			
					% Wind speed analisys
					if (choose_display == 1)
						close all;
						cd CoreFiles
							wind_speed_analisys;
						cd ..
					end;
			
					% Calculation of average power and energy
					if (choose_display == 2)
					
						choose_average_type = 0;	
						choose_average_type = menu('Average analysis', 'Wind Profile 1', 'Wind Profile 2', 'Wind Profile 3'); 
						close all;
						
						if (choose_average_type == 1)
							cd CoreFiles
							cd WindProfiles
								WindDistribution1;
							cd ..
								average_analisys;
							cd ..	
						end;
						
						if (choose_average_type == 2)
							cd CoreFiles
							cd WindProfiles
								WindDistribution2;
							cd ..
								average_analisys;
							cd ..	
						end;
						
						if (choose_average_type == 3)
							cd CoreFiles
							cd WindProfiles
								WindDistribution3;
							cd ..
								average_analisys;
							cd ..	
						end;
					end;
				end;		
			end;
		end;
	end;
	
	%[2] Generator Analisys
	if (choose == 2)
		choose_generator_analysis = 0;
		while (choose_generator_analysis < 3)
			choose_generator_analysis = menu('Generator Dedicated Analisys', 'Generator Analisys with selected torque-speed characteristic', '3D generator map', 'Return back'); 
			
			if (choose_generator_analysis == 1)
			choose_generator_an_sub = 0;
				while (choose_generator_an_sub < 3)
					choose_generator_an_sub = menu ('Generator Analisys with selected torque-speed characteristic', 'Chose torque-speed characteristic and generator type', 'Display results', 'Return back');
						
					if (choose_generator_an_sub == 1)
						count_generators = count_generators + 1;
						
						% Configuration choice
						choose_generator_profile = 0;
						
						% Get names from directory
						cd CoreFiles
						cd ConfigurationFiles
						configuration_directory = dir(fullfile('*.m'));
						configuration_number_of_files = length(configuration_directory);
						cd ..
						cd ..
						% Get only the file name and remove file extension
						for temp_configuration_files = 1:configuration_number_of_files
							configuration_directory_file = configuration_directory(temp_configuration_files).name;
							[pathstr,name,ext] = fileparts(configuration_directory_file);
							configuration_directory_final{temp_configuration_files} = name;
						end
				
						choose_generator_profile = menu('Choose configuration file (Torque-Speed characteristic and components parameters)', configuration_directory_final);
						configuration_file_name{count_generators} = configuration_directory_final{choose_generator_profile};
									
						% Electric generator choice
						choose_generator_spec = 0; 
				
						% Get names from directory
						cd CoreFiles
						cd ElectricGeneratorModels
						ElectricGenerator_directory = dir(fullfile('*.m'));
						ElectricGenerator_number_of_files = length(ElectricGenerator_directory);
						cd ..
						cd ..
						% Get only the file name and remove file extension
						for temp_ElectricGenerator_files = 1:ElectricGenerator_number_of_files
							ElectricGenerator_directory_file = ElectricGenerator_directory(temp_ElectricGenerator_files).name;
							[pathstr,name,ext] = fileparts(ElectricGenerator_directory_file);
							ElectricGenerator_directory_final{temp_ElectricGenerator_files} = name;
						end
				
						choose_generator_spec = menu('Choose generator model', ElectricGenerator_directory_final);
						ElectricGenerator_file_name{count_generators} = ElectricGenerator_directory_final{choose_generator_spec};
					
					end;
					
					if (choose_generator_an_sub == 2)
						close all;
						cd CoreFiles
							special_generator_analisys;
						cd ..
					end;
				end;
			end;
				
			if (choose_generator_analysis == 2)
			choose_generator_su_sub = 0;
				while (choose_generator_su_sub < 3)
					choose_generator_su_sub = menu ('3D generator map', 'Choose generator type and configuration file', 'Display results', 'Return back');
						
					if (choose_generator_su_sub == 1)
						count_generators = count_generators + 1;
						
						% Configuration choice
						choose_generator_profile = 0;
						
						% Get names from directory
						cd CoreFiles
						cd ConfigurationFiles
						configuration_directory = dir(fullfile('*.m'));
						configuration_number_of_files = length(configuration_directory);
						cd ..
						cd ..
						% Get only the file name and remove file extension
						for temp_configuration_files = 1:configuration_number_of_files
							configuration_directory_file = configuration_directory(temp_configuration_files).name;
							[pathstr,name,ext] = fileparts(configuration_directory_file);
							configuration_directory_final{temp_configuration_files} = name;
						end
				
						choose_generator_profile = menu('Choose configuration file (Torque-Speed characteristic and components parameters)', configuration_directory_final);
						configuration_file_name{count_generators} = configuration_directory_final{choose_generator_profile};
						
						% Electric generator choice
						choose_generator_spec = 0; 
						
						% Get names from directory
						cd CoreFiles
						cd ElectricGeneratorModels
						ElectricGenerator_directory = dir(fullfile('*.m'));
						ElectricGenerator_number_of_files = length(ElectricGenerator_directory);
						cd ..
						cd ..
						% Get only the file name and remove file extension
						for temp_ElectricGenerator_files = 1:ElectricGenerator_number_of_files
							ElectricGenerator_directory_file = ElectricGenerator_directory(temp_ElectricGenerator_files).name;
							[pathstr,name,ext] = fileparts(ElectricGenerator_directory_file);
							ElectricGenerator_directory_final{temp_ElectricGenerator_files} = name;
						end
				
						choose_generator_spec = menu('Choose generator model', ElectricGenerator_directory_final);
						ElectricGenerator_file_name{count_generators} = ElectricGenerator_directory_final{choose_generator_spec};
					end;
				
					if (choose_generator_su_sub == 2)
						close all;
						cd CoreFiles
						torque_step_string = input('\n\nInsert the Torque Step [Nm]: ', 's');
						torque_step(4, count_generators) = str2num(torque_step_string);
						torque_min_string = input('\n\nInsert the minimum Torque [Nm] (multiple of the step): ', 's');
						torque_min(4, count_generators) = str2num(torque_min_string);
						torque_max_string = input('\n\nInsert the maximum Torque [Nm] (multiple of the step): ', 's');
						torque_max(4, count_generators) = str2num(torque_max_string);
						speed_step_string = input('\n\nInsert the Speed step [rpm]: ', 's');
						speed_step(4, count_generators) = str2num(speed_step_string);
						speed_min_string = input('\n\nInsert the minimum Speed [rpm] (multiple of the step): ', 's');
						speed_min(4, count_generators) = str2num(speed_min_string);
						speed_max_string = input('\n\nInsert the maximum Speed [rpm] (multiple of the step): ', 's');
						speed_max(4, count_generators) = str2num(speed_max_string);
						constants;
						surface_analisys;
						cd ..
					end;
				end;
			end;
		end;
	end;
	
	%[3] Change system constants
	if (choose == 3)
		cd CoreFiles
		edit constants;
		cd ..
	end;
	
end;
