function paramstruct = TreadmillReward_CheckParamGUI( paramstruct )
% This function ensures that the parameter specified in the GUI make sense.
% 
% Maxime Maheu, (C)opyright 2022

% Make sure data saving flag is boolean
if ~any(paramstruct.Save_data ~= [0,1])
    warning('Data saving flag not valid');
    paramstruct.Save_data = 0;
end

% Make sure the path where to save the data exists on the computer
if exist(paramstruct.Path_to_data, 'dir') ~= 7
    warning('Data path not valid');
    paramstruct.Path_to_data = pwd;
end

% Make sure the lick detection method is amongst the two proposed ones
if ~any(paramstruct.Lick_detection_method ~= [1,2])
    warning('Data saving flag not valid');
    paramstruct.Save_data = 1;
end

% Make sure BNC identification ports are #1 or #2
if ~any(paramstruct.BNC_input_Reward_location ~= [1,2])
    warning('BNC ID not valid');
    paramstruct.BNC_input_Reward_location = 1;
end
if ~any(paramstruct.BNC_output_Licks ~= [1,2])
    warning('BNC ID not valid');
    paramstruct.BNC_output_Licks = 1;
end
if ~any(paramstruct.BNC_output_Rewards ~= [1,2])
    warning('BNC ID not valid');
    paramstruct.BNC_output_Rewards = 2;
end

% Make reward window visibility flag is boolean
if ~any(paramstruct.Reward_window_visibility ~= [0,1])
    warning('Reward window visibility flag not valid');
    paramstruct.Reward_window_visibility = 0;
end

% Make unlimited reward flag is boolean
if ~any(paramstruct.Unlimited_reward ~= [0,1])
    warning('Unlimited reward flag not valid');
    paramstruct.Unlimited_reward = 0;
end

% Make sure reward amount is null or positive
if paramstruct.Reward_amount < 0
    warning('Reward amount not valid');
    paramstruct.Reward_amount = 0;
end

% Make sure reward probability is between 0 and 1
if paramstruct.Reward_probability < 0 || paramstruct.Reward_probability > 1
    warning('Reward probability not valid');
    paramstruct.Reward_probability = 1;
end

% Make sure minimal number of lap parameters are null or positive
if paramstruct.Min_num_laps_before_first_catch < 0
    warning('Minimum number of laps not valid');
    paramstruct.Min_num_laps_before_first_catch = 0;
end
if paramstruct.Min_num_laps_between_catch < 0
    warning('Minimum number of laps not valid');
    paramstruct.Min_num_laps_between_catch = 0;
end

end