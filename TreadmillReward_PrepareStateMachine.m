function sma = TreadmillReward_PrepareStateMachine(S, param, TrialTypes, iRewLoc)
% This function creates the list of Bpod states required to run the
% protocol. Detailed description is specified below before each state.
% 
% Maxime Maheu, (C)opyright 2022

% Define the reward port to use
rewardport = 1;

% Create new state machine
sma = NewStateMachine;

% Wait for the animal to be in the reward zone
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

% Detects whether the animal is at the right (rewarding) position on
% the treadmill as detected by the BNC #1 input receiving high voltage.
sma = AddState(sma, ...
    'Name', 'DetectLicksAndPosition', ...
    'Timer', 0, ...
    'StateChangeConditions', {param.inportlabel, 'DetectedUnrewardedLicks', ...
                              param.highBNCid, 'PrepareRewardDelivery', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 0});

% Even if the animal is not at the rewarded position, we detect licks,
% which thus will stay unrewarded, and output a corresponding signal in
% one of the BNC output.
sma = AddState(sma, ...
    'Name', 'DetectedUnrewardedLicks', ...
    'Timer', 0, ...
    'StateChangeConditions', {param.outportlabel, 'DetectLicksAndPosition', ...
                              param.highBNCid, 'PrepareRewardDelivery', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 1});

% Prepare water delivery
% ~~~~~~~~~~~~~~~~~~~~~~

% If it is a regular trial, deliver reward as planned. By contrast, if
% it is a catch trial, skip reward delivery (but still record the
% animal's licks).
if     TrialTypes(iRewLoc) == 1, out = 'DetectedRewardedLicks';
elseif TrialTypes(iRewLoc) == 2, out = 'DetectedUnrewardedLicks';
end

% In the debugging mode, we turn on the LED when we receive the reward
% trigger in the BNC input to materialize the reward window.
if      S.GUI.Reward_window_visibility, LEDon = 255;
elseif ~S.GUI.Reward_window_visibility, LEDon = 0;
end

% In the automatic water delivery, we skip the verification of the licking
% and immediately proceed to reward delivery whenever the animal is in the 
% reward zone, even if it does not lick.
if      S.GUI.Automatic_reward_delivery, statechangecond = {'Tup', 'AutomaticRewardDelivery'};
elseif ~S.GUI.Automatic_reward_delivery, statechangecond = {param.inportlabel, out};
end

% If the animal is at the rewarding location and that it pocks to the
% reward port then proceed with the reward delivery. If, by contrast,
% the animal leaves the rewarding position without licking, the trial
% is terminated.
sma = AddState(sma, ...
    'Name', 'PrepareRewardDelivery', ...
    'Timer', 0,...
    'StateChangeConditions', [statechangecond, ...
                             {param.lowBNCid, 'exit'}], ...
    'OutputActions', {param.LEDid, LEDon});

% Automatic water delivery
% ~~~~~~~~~~~~~~~~~~~~~~~~

% In the case of automatic reward delivery, we open the valve whenever the
% animal is in the reward zone and wait for it to collect it.
sma = AddState(sma, ...
    'Name', 'AutomaticRewardDelivery', ...
    'Timer', param.ValveTime, ...
    'StateChangeConditions', {'Tup', 'WaitingForWaterCollection', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {'ValveState', rewardport, ...
                      param.outBNCidRwrds, 1, ...
                      param.LEDid, LEDon});

% Detect when the animal collects the automatically delivered water reward.
sma = AddState(sma, ...
    'Name', 'WaitingForWaterCollection', ...
    'Timer', 0, ...
    'StateChangeConditions', {param.inportlabel, 'WaterCollected', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.LEDid, LEDon});

% Conditional water delivery
% ~~~~~~~~~~~~~~~~~~~~~~~~~~

% Deliver water through the valve. Delivery is stopped after a given
% amount of time (which controls the amount of water delivered to the
% animal on each iteration).
sma = AddState(sma, ...
    'Name', 'DetectedRewardedLicks', ...
    'Timer', param.ValveTime, ...
    'StateChangeConditions', {'Tup', 'Drinking', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {'ValveState', rewardport, ...
                      param.outBNCidLicks, 1, ...
                      param.outBNCidRwrds, 1, ...
                      param.LEDid, LEDon});

% The animal is then allowed to drink.
sma = AddState(sma, ...
    'Name', 'Drinking', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'WaterCollected', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 1, ...
                      param.LEDid, LEDon});

% Water collected
% ~~~~~~~~~~~~~~~

% Here, we divide between two options. Either, the animal is allowed to
% get infinite amount of reward at each rewarding location, or only one
% reward unit is allowed.
if      S.GUI.Unlimited_reward, out = 'PrepareRewardDelivery';
elseif ~S.GUI.Unlimited_reward, out = 'DetectLicksAndPosition';
end

% Once water is collected, either returns to lick detection without water
% delivery or proceed with new water delivery if (1) the animal is
% still in the reward zone and (2) the corresponding GUI parameter 
% (Unlimited_reward) has been enabled.
sma = AddState(sma, ...
    'Name', 'WaterCollected', ...
    'Timer', 0,...
    'StateChangeConditions', {param.outportlabel, out, ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 1, ...
                      param.LEDid, LEDon});

end