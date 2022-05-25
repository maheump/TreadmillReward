function Outcomes = TreadmillReward_UpdatePlots(S, TrialTypes, Outcomes, iRewLoc)
% This function updates the plots during the course of the experiment.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% In the automatic reward delivery method vs. regular experiment, adapt to
% different state names corresponding to mouse licking water
if S.GUI.Automatic_reward_delivery
    field = BpodSystem.Data.RawEvents.Trial{iRewLoc}.States.WaterCollected;
elseif ~S.GUI.Automatic_reward_delivery
    field = BpodSystem.Data.RawEvents.Trial{iRewLoc}.States.DetectedRewardedLicks;
end

% Update the amount of reward given to the animal
NumOfRewardDeliveries = sum(~isnan(field(1:2:end)));
RewardAmount = NumOfRewardDeliveries * S.GUI.Reward_amount;
TotalRewardDisplay('add', RewardAmount);

% Update the outcome plot
NumOfRewardDeliveries = sum(~isnan(field(1:2:end)));
Outcomes(iRewLoc) = double(NumOfRewardDeliveries > 0);
TrialTypeOutcomePlot(BpodSystem.GUIHandles.OutcomePlot, ...
    'update', iRewLoc + 1, TrialTypes, Outcomes(1:iRewLoc));
    
end