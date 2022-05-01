function [TrialTypes, Outcomes] = TreadmillReward_CreateTrialList(S, MaxRewLoc)
% This function creates the list of trial types, essentially dictating
% whether each trial will be a regular (with reward) or catch trial (with
% omitted reward). This is controlled by the reward probability speficied
% in the parameter GUI.
% 
% Maxime Maheu, (C)opyright 2022

% Shuffle the seed for the random number generator (used to decide whether
% to reward all trials or only a subset of them, randomly)
rng('shuffle');

% Create list of trials (1 is rewarded, 2 is non-rewarded)
TrialTypes = double(rand(1, MaxRewLoc) > S.GUI.Reward_probability) + 1;

% Prepare outcome variable of same size
Outcomes = zeros(1, MaxRewLoc);

end