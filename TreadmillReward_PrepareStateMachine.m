function sma = TreadmillReward_PrepareStateMachine(S, param, TrialTypes, iRewLoc, debug)
% This function creates the list of Bpod states required to run the
% protocol. Detailed description is specified below before each state.
% 
% Maxime Maheu, (C)opyright 2022

% In the debugging mode, we turn on the LED when we receive the reward
% trigger in the BNC input
if nargin < 5, debug = false; end
if debug, outputaction = {'LED', 1};
else, outputaction = {};
end

% Create new state machine
sma = NewStateMachine;

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

% If it is a regular trial, deliver reward as planned. By contrast, if
% it is a catch trial, skip reward delivery (but still record the
% animal's licks)
if     TrialTypes(iRewLoc) == 1, out = 'DetectedRewardedLicks';
elseif TrialTypes(iRewLoc) == 2, out = 'DetectedUnrewardedLicks';
end

% If the animal is at the rewarding location and that it pocks to the
% reward port then proceed with the reward delivery. If, by contrast,
% the animal leaves the rewarding position without licking, the trial
% is terminated.
sma = AddState(sma, ...
    'Name', 'PrepareRewardDelivery', ...
    'Timer', 0,...
    'StateChangeConditions', {param.inportlabel, out, ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', outputaction);

% Here, we divide between two options. Either, the animal is allowed to
% get infinite amount of reward at each rewarding location, ot only one
% reward unit is allowed.
if      S.GUI.Unlimited_reward, out = 'PrepareRewardDelivery';
elseif ~S.GUI.Unlimited_reward, out = 'DetectLicksAndPosition';
end

% Deliver water through the valve. Delivery is stopped after a given
% amount of time (which controls the amount of water deliver to the
% animal on each iteration).
sma = AddState(sma, ...
    'Name', 'DetectedRewardedLicks', ...
    'Timer', param.ValveTime, ...
    'StateChangeConditions', {'Tup', 'Drinking1'}, ...
    'OutputActions', {'ValveState', S.GUI.Reward_port, ...
                      param.outBNCidLicks, 1, ...
                      param.outBNCidRwrds, 1});
% N.B. use the following StateChangeConditions if you want to stop
% reward delivery when the animal pokes out or leaves the reward zone:
% 'StateChangeConditions', {'Tup', 'Drinking1', ...
%                           outportlabel, out, ...
%                           lowBNCid, 'exit'}, ...

% The animal is then allowed to drink. When the animal stops drinking
% and pocks out of the port, we return to either a state where the
% animal can start licking again for a new reward if it is still at the
% rewarding position, or move to a wait state until reward location is
% leaved, and trial terminated (and then entered again at the next
% trial). The double drinking states ensures that licks correctly
% trigger the BNC output there as well (and not only for unrewarded
% licks).
sma = AddState(sma, ...
    'Name', 'Drinking1', ...
    'Timer', 0,...
    'StateChangeConditions', {'Tup', 'Drinking2', ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 1});
sma = AddState(sma, ...
    'Name', 'Drinking2', ...
    'Timer', 0,...
    'StateChangeConditions', {param.outportlabel, out, ...
                              param.lowBNCid, 'exit'}, ...
    'OutputActions', {param.outBNCidLicks, 1});

end