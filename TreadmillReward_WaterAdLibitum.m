function TreadmillReward_WaterAdLibitum
% This is a simple Bpod protocol which gives water reward whenever the
% animal pokes.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Load settings chosen in launch manager
S = BpodSystem.ProtocolSettings;

% Define which reward port to use
rewardport = 1;

% Define the amount of water reward to deliver
rewardamount = 2; % microliters

% Convert amount of reward into duration of solenoid valve opening
ValveTime = GetValveTimes(rewardamount, rewardport);

% Create new state machine
sma = NewStateMachine;

% Add a state which simply awaits that the animal pokes in a port
sma = AddState(sma, ...
    'Name', 'WaitForPoke', ...
    'Timer', 0,...
    'StateChangeConditions', {sprintf('Port%iIn', rewardport), 'DeliverReward'}, ...
    'OutputActions', {});

% If poke is detected, deliver the predefined amount of reward. Once that
% is done, we return (without time delay) to a state in which we wait for
% pokes 
sma = AddState(sma, ...
    'Name', 'DeliverReward', ...
    'Timer', ValveTime, ...
    'StateChangeConditions', {'Tup', 'WaitForPoke'}, ...
    'OutputActions', {'ValveState', rewardport});

% Send state machine to the Bpod state machine device
SendStateMatrix(sma);

% Run the trial and return events
RunStateMatrix;

end