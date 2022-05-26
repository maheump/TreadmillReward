function TreadmillReward_CreatePlots(TrialTypes)
% This function creates the plots before starting the experiment.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Create a figure displaying the total amount of reward delivered
TotalRewardDisplay('init');
set(BpodSystem.ProtocolFigures.TotalRewardDisplay, 'Position', [80 758 150 150]);

% Create a figure for the outcome plot
BpodSystem.ProtocolFigures.OutcomePlotFig = figure('Name', ...
    'Trial type outcome plot', 'NumberTitle', 'Off', 'MenuBar', 'None', ...
    'Resize', 'Off', 'Color', 'w', 'Position', [80 529 825 200]);
BpodSystem.GUIHandles.OutcomePlot = axes('Position', [.075 .3 .89 .6]);
TrialTypeOutcomePlot(BpodSystem.GUIHandles.OutcomePlot, 'init', TrialTypes);

end