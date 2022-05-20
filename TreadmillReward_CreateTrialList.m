function [TrialTypes, Outcomes] = TreadmillReward_CreateTrialList(S, MaxRewLoc, iRewLoc)
% This function creates the list of trial types, essentially dictating
% whether each trial will be a regular (with reward) or catch trial (with
% omitted reward). This is controlled by the reward probability speficied
% in the parameter GUI.
% 
% Maxime Maheu, (C)opyright 2022

% By default, create (not update) the full trial list, starting with trial
% #1
if nargin < 3, iRewLoc = 1; end

% Shuffle the seed for the random number generator (used to decide whether
% to reward all trials or only a subset of them, randomly)
rng('shuffle');

% Loop over trials
TrialTypes = ones(1,MaxRewLoc);
for j = iRewLoc:MaxRewLoc
    
    % Make sure we do not omit reward in the first trials
    if j > S.GUI.Min_num_laps_before_first_catch
        
        % Make sure reward was not omitted in the last couple of trials
        i = max([1, j - S.GUI.Min_num_laps_between_catch]);
        PrevTrials = TrialTypes(i:(j-1));
        if all(PrevTrials == 1)
            
            % Throw a biased coin
            coin = rand > S.GUI.Reward_probability;
            
            % If positive, omit reward on this trial
            TrialTypes(j) = TrialTypes(j) + coin;
        end
    end
end

% Return only part of the sequence in case the function is called to update
% the trial list only
n = MaxRewLoc-iRewLoc+1;
TrialTypes = TrialTypes((MaxRewLoc-n+1):end);

% Prepare outcome variable of same size
Outcomes = zeros(1, n);

end