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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%       Permanent magnet synchronous generator        %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Model partially derived from                                           %
%  S.M.Muyeen, Wind Energy Conversion Systems,                            %
%  Green energy and technology, Springer                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS
% omega_gear        	% generator rotationspeed (equal to the gear rotation speed if present)
% T_gear		  		% input Torque (equal to the gear torque if present)

% OUTPUTS 
% V_generator   		% output voltage
% I_generator   		% output current
% P_generator   		% output power         
% eta_generator 		% generator efficiency                                   
% T_generator   		% output torque
% T_losses_generator    % total torque loss
% P_losses_mechanical   % mechanical losses
% P_losses_copper		% copper losses	
% P_losses_core			% core losses
% P_losses_additional	% additional losses
% P_losses_excitation	% ecitation losses

flag_generator_exist(chosen_solution) = 1;   % flag used during the graph generation to identify if the component exist or not

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% GENERAL INPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gen_ng(chosen_solution, wind_i) = omega_gear(chosen_solution, wind_i)*30/pi;
T_input_gen(chosen_solution, wind_i) = T_gear(chosen_solution, wind_i);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% SPECIFIC GENERATOR MODEL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_ng_pu(chosen_solution, wind_i) = gen_ng(chosen_solution, wind_i) / PM_ng_N;    % permanent magnets generator speed per unit

%%%%%%%%%%%%%%%%%%%   Mechanical losses    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_tu_pu(chosen_solution, wind_i) = PM_tu_ss_pu + (PM_tu_n_pu - PM_tu_ss_pu)*PM_ng_pu(chosen_solution, wind_i);  % torque per unit
PM_Tu(chosen_solution, wind_i) = PM_tu_pu(chosen_solution, wind_i) * PM_TG_N;            % [Nm]

PM_pu_pu(chosen_solution, wind_i) = PM_tu_pu(chosen_solution, wind_i) * PM_ng_pu(chosen_solution, wind_i);      % power per unit
PM_Pu(chosen_solution, wind_i) = PM_pu_pu(chosen_solution, wind_i) * PM_PG_N;      % power [W]

%%%%%%%%%%%%%%%%%%%   Core losses          %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_pef_pu(chosen_solution, wind_i) = PM_K_core1 * PM_ng_pu(chosen_solution, wind_i) + PM_K_core2 * PM_ng_pu(chosen_solution, wind_i)^2;
PM_Pef(chosen_solution, wind_i) = PM_pef_pu(chosen_solution, wind_i) * PM_PG_N;             % [W] power 

PM_tef_pu(chosen_solution, wind_i) = PM_pef_pu(chosen_solution, wind_i) / PM_ng_pu(chosen_solution, wind_i); % torque per unit
PM_Tef(chosen_solution, wind_i) = PM_tef_pu(chosen_solution, wind_i) * PM_TG_N; % torque [Nm]

%%%%%%%%%%%%%%%%%%%   Additional losses    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_Pad(chosen_solution, wind_i) = PM_Pad_nom;             % [W] power

PM_Tad(chosen_solution, wind_i) = PM_Pad(chosen_solution, wind_i) / (gen_ng(chosen_solution, wind_i)*pi/30); % torque [Nm]

%%%%%%%%%%%%%%%%%%%   Copper losses        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evaluated considering that all the power produced by the generator is absorbed by the load
PM_Ptemp(chosen_solution, wind_i) = P_gear(chosen_solution, wind_i_temp) - PM_Pu(chosen_solution, wind_i) - PM_Pef(chosen_solution, wind_i) - PM_Pad(chosen_solution, wind_i);

PM_Za(chosen_solution, wind_i) = PM_Ra_N;

Vtemp(chosen_solution, wind_i) = (PM_E0_N_ng* ((PM_p*gen_ng(chosen_solution, wind_i))/60));
PM_ia(chosen_solution, wind_i) = PM_Ptemp(chosen_solution, wind_i)/Vtemp(chosen_solution, wind_i);

PM_Pc(chosen_solution, wind_i) = PM_Ra_N * PM_ia(chosen_solution, wind_i)^2;    % power [W]

PM_Tc(chosen_solution, wind_i) = PM_Pc(chosen_solution, wind_i)/(gen_ng(chosen_solution, wind_i)*pi/30);    % torque [Nm]  

%%%%%%%%%%%%%%%%%%    Total losses         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_tot_loss(chosen_solution, wind_i) = PM_Pu(chosen_solution, wind_i) + PM_Pc(chosen_solution, wind_i) + PM_Pad(chosen_solution, wind_i) + PM_Pef(chosen_solution, wind_i);            %total losses [W]

PM_tot_t_loss(chosen_solution, wind_i) = PM_Tu(chosen_solution, wind_i) + PM_Tc(chosen_solution, wind_i) + PM_Tad(chosen_solution, wind_i) + PM_Tef(chosen_solution, wind_i);           %total torque losses [Nm]


%%%%%%%%%%%%%%%%%%    Others               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PM_out_voltage(chosen_solution, wind_i) = (PM_E0_N_ng* ((PM_p*gen_ng(chosen_solution, wind_i))/60)) - (PM_Za(chosen_solution, wind_i)*PM_ia(chosen_solution, wind_i)) ;      % Output Voltage
if PM_out_voltage(chosen_solution, wind_i) < 0
	PM_out_voltage(chosen_solution, wind_i) = 0;
end;
PM_out_power(chosen_solution, wind_i) = (T_input_gen(chosen_solution, wind_i) - PM_tot_t_loss(chosen_solution, wind_i))*omega_gear(chosen_solution, wind_i);    % Output Power
if PM_out_power(chosen_solution, wind_i) < 0
	PM_out_power(chosen_solution, wind_i) = 0;
end;
PM_efficiency(chosen_solution, wind_i) = PM_out_power(chosen_solution, wind_i)/(PM_out_power(chosen_solution, wind_i)+PM_tot_loss(chosen_solution, wind_i));              % Generator efficiency




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% GENERAL OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T_losses_generator(chosen_solution, wind_i) = PM_tot_t_loss(chosen_solution, wind_i);
P_losses_mechanical(chosen_solution, wind_i) = PM_Pu(chosen_solution, wind_i);
P_losses_copper(chosen_solution, wind_i) = PM_Pc(chosen_solution, wind_i);
P_losses_core(chosen_solution, wind_i) = PM_Pef(chosen_solution, wind_i);
P_losses_additional(chosen_solution, wind_i) = PM_Pad(chosen_solution, wind_i);
P_losses_excitation(chosen_solution, wind_i) = 0;


V_generator(chosen_solution, wind_i) = PM_out_voltage(chosen_solution, wind_i);
I_generator(chosen_solution, wind_i) = PM_ia(chosen_solution, wind_i);		
P_generator(chosen_solution, wind_i) = PM_out_power(chosen_solution, wind_i);	                   
eta_generator(chosen_solution, wind_i) = PM_efficiency(chosen_solution, wind_i);                                          
T_generator(chosen_solution, wind_i) = T_gear(chosen_solution, wind_i) - PM_tot_t_loss(chosen_solution, wind_i);  
