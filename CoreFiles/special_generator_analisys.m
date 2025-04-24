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
flag_energy_analisys = 0;
for chosen_solution=1:count_generators
	flagfixedspeed(chosen_solution) = 0;
	constants;
	count_solutions = chosen_solution;
	
	cd ConfigurationFiles
	    wind_i = 1;
		eval(configuration_file_name{chosen_solution});
	cd ..

    % for each angular speed
	for wind_i=1:speed_range_point
		wind_i_temp = wind_i;
		P_gear(chosen_solution, wind_i) = P_input(chosen_solution, wind_i);
		omega_gear(chosen_solution, wind_i) = turbine_omega_wind(chosen_solution, wind_i);
		T_gear(chosen_solution, wind_i) = T_wind(chosen_solution, wind_i);
			
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
		Output_current(chosen_solution, wind_i) = I_generator(chosen_solution, wind_i);
		Output_power(chosen_solution, wind_i) = P_generator(chosen_solution, wind_i);
		Gen_efficiency(chosen_solution, wind_i) = eta_generator(chosen_solution, wind_i);
	end;
end;

%for i_ttemp=1:count_generators
%	figure(i_ttemp)
%	plot(squeeze(turbine_omega_wind(i_ttemp, :)), squeeze(T_wind(i_ttemp, :)),'-*b');
%	name_tmp_1 = strcat('Torque-Speed Curve: Solution ', int2str(i_ttemp));
%	xtitle = title(name_tmp_1);
%	set(xtitle,'Fontsize',15);
%	xhandle = xlabel('Angular speed [rpm]');
%	yhandle = ylabel('Torque [Nm]');
%	set(xhandle,'Fontsize',15);
%	set(yhandle,'Fontsize',15);
%	grid on;
%end;

figure(1)
col=hsv(count_generators);
for i_ttemp=1:count_generators
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp));
	if flagfixedspeed(i_ttemp) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(P_input(i_ttemp, :)), '*-','LineWidth', 2, 'color',col(i_ttemp,:), 'DisplayName',name_tmp_1);
	elseif flagfixedspeed(i_ttemp) == 1
		plot(squeeze(T_wind(i_ttemp, :)),squeeze(P_input(i_ttemp, :)), '*-','LineWidth', 2, 'color',col(i_ttemp,:), 'DisplayName',name_tmp_1);
	end;
	hold on;
end;
hold off;
xtitle = title('Input Power');
set(xtitle,'Fontsize',15);
if flagfixedspeed(i_ttemp) == 0
	xhandle = xlabel('Angular speed [rpm]');
elseif flagfixedspeed(i_ttemp) == 1
	xhandle = xlabel('Torque [Nm]');
end;
yhandle = ylabel('Power [W]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
legend('show');

figure(2)
col=hsv(count_generators);
for i_ttemp=1:count_generators
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp));
	if flagfixedspeed(i_ttemp) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(T_wind(i_ttemp, :)), '*-','LineWidth', 2, 'color',col(i_ttemp,:), 'DisplayName',name_tmp_1);
	elseif flagfixedspeed(i_ttemp) == 1
		plot(squeeze(T_wind(i_ttemp, :)),squeeze(T_wind(i_ttemp, :)), '*-','LineWidth', 2, 'color',col(i_ttemp,:), 'DisplayName',name_tmp_1);
	end;
	hold on;
end;
hold off;
xtitle = title('Torque-Speed Curve');
set(xtitle,'Fontsize',15);
if flagfixedspeed(i_ttemp) == 0
	xhandle = xlabel('Angular speed [rpm]');
elseif flagfixedspeed(i_ttemp) == 1
	xhandle = xlabel('Torque [Nm]');
end;
yhandle = ylabel('Torque [Nm]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
legend('show');

figure(3)
col=hsv(count_generators);
for i_ttemp4=1:count_generators
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp4));
	if flagfixedspeed(i_ttemp4) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp4, :)),squeeze(Output_power(i_ttemp4, :)), '*-','LineWidth', 2, 'color',col(i_ttemp4,:), 'DisplayName',name_tmp_1);
	elseif flagfixedspeed(i_ttemp4) == 1
		plot(squeeze(T_wind(i_ttemp4, :)),squeeze(Output_power(i_ttemp4, :)), '*-','LineWidth', 2, 'color',col(i_ttemp4,:), 'DisplayName',name_tmp_1);
	end;
	hold on;
end;
hold off;
xtitle = title('Output Power');
set(xtitle,'Fontsize',15);
if flagfixedspeed(i_ttemp4) == 0
	xhandle = xlabel('Angular speed [rpm]');
elseif flagfixedspeed(i_ttemp4) == 1
	xhandle = xlabel('Torque [Nm]');
end;
yhandle = ylabel('Output power [W]');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
legend('show');

figure(4)
col=hsv(count_generators);
for i_ttemp5=1:count_generators
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp5));
	if flagfixedspeed(i_ttemp5) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp5, :)),squeeze(Gen_efficiency(i_ttemp5, :)), '*-','LineWidth', 2, 'color',col(i_ttemp5,:), 'DisplayName',name_tmp_1);
	elseif flagfixedspeed(i_ttemp5) == 1
		plot(squeeze(T_wind(i_ttemp5, :)),squeeze(Gen_efficiency(i_ttemp5, :)), '*-','LineWidth', 2, 'color',col(i_ttemp5,:), 'DisplayName',name_tmp_1);
	end;
	hold on;
end;
hold off;
xtitle = title('Generator Efficiency');
set(xtitle,'Fontsize',15);
if flagfixedspeed(i_ttemp5) == 0
	xhandle = xlabel('Angular speed [rpm]');
elseif flagfixedspeed(i_ttemp5) == 1
	xhandle = xlabel('Torque [Nm]');
end;
yhandle = ylabel('Efficiency');
set(xhandle,'Fontsize',15);
set(yhandle,'Fontsize',15);
grid on;
legend('show');

for i_ttemp=1:count_generators
	figure(4+i_ttemp)
	if flagfixedspeed(i_ttemp) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(Delta_P_mech(i_ttemp, :)), '-*b', squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(Delta_P_copper(i_ttemp, :)), '-*r', squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(Delta_P_core(i_ttemp, :)), '-*g', squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(Delta_P_add(i_ttemp, :)), '-*k', squeeze(turbine_omega_wind_rpm(i_ttemp, :)),squeeze(Delta_P_exch(i_ttemp, :)), '-*m');
		xhandle = xlabel('Angular speed [rpm]');
	elseif flagfixedspeed(i_ttemp) == 1
		plot(squeeze(T_wind(i_ttemp, :)),squeeze(Delta_P_mech(i_ttemp, :)), '-*b', squeeze(T_wind(i_ttemp, :)),squeeze(Delta_P_copper(i_ttemp, :)), '-*r', squeeze(T_wind(i_ttemp, :)),squeeze(Delta_P_core(i_ttemp, :)), '-*g', squeeze(T_wind(i_ttemp, :)),squeeze(Delta_P_add(i_ttemp, :)), '-*k', squeeze(T_wind(i_ttemp, :)),squeeze(Delta_P_exch(i_ttemp, :)), '-*m');
		xhandle = xlabel('Torque [Nm]');
	end;
	legend('Mechanical', 'Copper', 'Core', 'Additional', 'Excitation');
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp));
	xtitle = title(name_tmp_1);
	set(xtitle,'Fontsize',15);
	yhandle = ylabel('Generator Losses [W]');
	set(xhandle,'Fontsize',15);
	set(yhandle,'Fontsize',15);
	grid on;
end;

for i_ttemp3=1:count_generators
	figure(4+i_ttemp3+count_generators)
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp3));
	if flagfixedspeed(i_ttemp3) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp3, :)),squeeze(Output_voltage(i_ttemp3, :)), '-*b');
		xhandle = xlabel('Angular speed [rpm]');
	elseif flagfixedspeed(i_ttemp3) == 1
		plot(squeeze(T_wind(i_ttemp3, :)),squeeze(Output_voltage(i_ttemp3, :)), '-*b');
		xhandle = xlabel('Torque [Nm]');
	end;
	xtitle = title(name_tmp_1);
	set(xtitle,'Fontsize',15);
	yhandle = ylabel('Output voltage [V]');
	set(xhandle,'Fontsize',15);
	set(yhandle,'Fontsize',15);
	grid on;
end;

for i_ttemp4=1:count_generators
	figure(4+count_generators+count_generators+i_ttemp4)
	name_tmp_1 = strcat('Solution ', int2str(i_ttemp4));
	if flagfixedspeed(i_ttemp4) == 0
		plot(squeeze(turbine_omega_wind_rpm(i_ttemp4, :)),squeeze(Output_current(i_ttemp4, :)), '-*b');
		xhandle = xlabel('Angular speed [rpm]');
	elseif flagfixedspeed(i_ttemp4) == 1
		plot(squeeze(T_wind(i_ttemp4, :)),squeeze(Output_current(i_ttemp4, :)), '-*b');
		xhandle = xlabel('Torque [Nm]');
	end;
	xtitle = title(name_tmp_1);
	set(xtitle,'Fontsize',15);
	yhandle = ylabel('Output current [A]');
	set(xhandle,'Fontsize',15);
	set(yhandle,'Fontsize',15);
	grid on;
end;

%figure(3+count_generators+count_generators+count_generators+1)
%col=hsv(count_generators);
%for i_ttemp2=1:count_generators
%	name_tmp_1 = strcat('Solution ', int2str(i_ttemp2));
%	plot(squeeze(turbine_omega_wind_rpm(i_ttemp2, :)),squeeze(Total_torque_losses(i_ttemp2, :)), '*-','LineWidth', 2, 'color',col(i_ttemp2,:), 'DisplayName',name_tmp_1);
%	hold on;
%end;
%hold off;
%xtitle = title('Resistant Torque');
%set(xtitle,'Fontsize',15);
%xhandle = xlabel('Angular speed [rpm]');
%yhandle = ylabel('Resistant torque [Nm]');
%set(xhandle,'Fontsize',15);
%set(yhandle,'Fontsize',15);
%grid on;
%legend('show');
