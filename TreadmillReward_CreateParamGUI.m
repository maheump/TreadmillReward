function S = TreadmillReward_CreateParamGUI(S)
% This function creates the paramater GUI and sets the default value for 
% these parameters before starting the experiment.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Get location where datafiles are saved
fullpath = BpodSystem.Path.CurrentDataFile;
path2data = fileparts(fullpath);

% Specify default parameters
S.GUI.Save_data                 = 0;         % whether to save data as MATLAB file
S.GUI.Path_to_data              = path2data; % path where data is saved
S.GUI.Lick_detection_method     = 1;         % type of lick detection
S.GUI.BNC_input_Reward_location = 1;         % BNC input ID
S.GUI.BNC_output_Licks          = 1;         % BNC output ID
S.GUI.BNC_output_Rewards        = 2;         % BNC output ID
S.GUI.Reward_window_visibility  = 0;         % boolean
S.GUI.Unlimited_reward          = 0;         % boolean
S.GUI.Reward_amount             = 2;         % microliter(s)
S.GUI.Reward_probability        = 0.9;       % probability

% Specify that some of those parameters should be shown as check boxes
S.GUIMeta.Save_data.Style = 'CheckBox';
S.GUIMeta.Reward_window_visibility.Style = 'CheckBox';
S.GUIMeta.Unlimited_reward.Style = 'CheckBox';

% Add a pop-up menu which specifies which lick detection method to use
S.GUIMeta.Lick_detection_method.Style = 'PopUpMenu';
S.GUIMeta.Lick_detection_method.String = {'Camera + Bonsai', 'Photogate'};

% Create subfields in the GUI
S.GUIPanels.Data = {'Save_data', 'Path_to_data'};
S.GUIPanels.Connections = {'Lick_detection_method', 'BNC_input_Reward_location', ...
    'BNC_output_Licks', 'BNC_output_Rewards'};
S.GUIPanels.Rewards = {'Reward_window_visibility', 'Unlimited_reward', ...
    'Reward_amount', 'Reward_probability'};

% Create GUI with task parameters
BpodParameterGUI('init', S);
set(BpodSystem.ProtocolFigures.ParameterGUI, 'Position', [906 100 460 520]);

end