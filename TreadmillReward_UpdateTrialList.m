function TrialTypes = TreadmillReward_UpdateTrialList(S, TrialTypes, iRewLoc)
% This function updates the list of trial type, that is whether they are
% regular (with reward) or catch trials (with omitted reward). The list is
% updated only if the reward probability is changed by the experimenter
% online during the course of an experiment. The change only impacts future
% trials.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Get previous reward probability
PrevProba = BpodSystem.Data.TrialSettings(iRewLoc-1).GUI.Reward_probability;

% Get current reward probability
CurrProba = S.GUI.Reward_probability;

% If previous and current reward probabilities differ, it means they have
% been updated in between trials
if PrevProba ~= CurrProba
    
    % Thus create a new trial list for the trials that were not yet presented
    TrialTypes(iRewLoc:end) = TreadmillReward_CreateTrialList(MaxRewLoc-iRewLoc+1, CurrProba);
end
    
end