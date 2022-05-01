function param = TreadmillReward_TransformGuiParams(S)
% This function reads in the parameters specified in the parameter GUI
% window and transforms then such that they can later on be used to create
% states that Bpod can understand (by TreadmillReward_PrepareStateMachine).
% 
% Maxime Maheu, (C)opyright 2022

% Create empty structure
param = struct;

% Get valve times
param.ValveTime = GetValveTimes(S.GUI.Reward_amount, S.GUI.Reward_port);

% Get port/valve ID
param.outportlabel = sprintf('Port%iOut', S.GUI.Reward_port);
param.inportlabel  = sprintf('Port%iIn',  S.GUI.Reward_port);

% Get the ID of reward input BNC
param.lowBNCid  = sprintf('BNC%iLow',  S.GUI.BNC_input_Reward_location);
param.highBNCid = sprintf('BNC%iHigh', S.GUI.BNC_input_Reward_location);

% Get the Id of output BNC
param.outBNCidLicks = sprintf('BNC%i', S.GUI.BNC_output_Licks);
param.outBNCidRwrds = sprintf('BNC%i', S.GUI.BNC_output_Rewards);
    
end