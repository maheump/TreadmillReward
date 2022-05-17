function param = TreadmillReward_TransformGuiParams(S)
% This function reads in the parameters specified in the parameter GUI
% window and transforms then such that they can later on be used to create
% states that Bpod can understand (by TreadmillReward_PrepareStateMachine).
% 
% Maxime Maheu, (C)opyright 2022

% Create empty structure
param = struct;

% Get valve times
rewardport = 1;
param.ValveTime = GetValveTimes(S.GUI.Reward_amount, rewardport);

% Get port/valve ID
methodlist = S.GUIMeta.Lick_detection_method.String;
idmethod = S.GUI.Lick_detection_method;
if strcmpi(methodlist{idmethod}, 'Camera + Bonsai')
    param.inportlabel  = 'SoftCode1';
    param.outportlabel = 'SoftCode2';
elseif strcmpi(methodlist{idmethod}, 'Photogate')
    param.inportlabel  = sprintf('Port%iIn',  rewardport);
    param.outportlabel = sprintf('Port%iOut', rewardport);
end
param.LEDid = sprintf('PWM%i', rewardport);

% Get the ID of reward input BNC
param.lowBNCid  = sprintf('BNC%iLow',  S.GUI.BNC_input_Reward_location);
param.highBNCid = sprintf('BNC%iHigh', S.GUI.BNC_input_Reward_location);

% Get the Id of output BNC
param.outBNCidLicks = sprintf('BNC%i', S.GUI.BNC_output_Licks);
param.outBNCidRwrds = sprintf('BNC%i', S.GUI.BNC_output_Rewards);

end