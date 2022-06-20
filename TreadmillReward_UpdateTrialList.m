function TrialTypes = TreadmillReward_UpdateTrialList(S, prevS, TrialTypes, iRewLoc, MaxRewLoc)
% This function updates the list of trial type, that is whether they are
% regular (with reward) or catch trials (with omitted reward). The list is
% updated only if the reward parameters have been changed by the 
% experimenter online during the course of an experiment. The change only
% impacts future trials.
% 
% Maxime Maheu, (C)opyright 2022

% Get previous reward parameter
PrevParam = cat(2, prevS.GUI.Reward_probability, ...
                   prevS.GUI.Min_num_laps_before_first_catch, ...
                   prevS.GUI.Min_num_laps_between_catch);

% Get current reward probability
CurrParam = cat(2, S.GUI.Reward_probability, ...
                   S.GUI.Min_num_laps_before_first_catch, ...
                   S.GUI.Min_num_laps_between_catch);

% If previous and current reward parameters differ, it means they have been
% updated in between trials
if any(PrevParam ~= CurrParam)
    
    % Thus create a new trial list for the trials that were not yet presented
    TrialTypes(iRewLoc:end) = TreadmillReward_CreateTrialList(S, MaxRewLoc, iRewLoc);
end
    
end