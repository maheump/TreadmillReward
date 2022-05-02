function TreadmillReward_RunStateMachine
% TREADMILLREWARD is a Bpod protocol which delivers reward whenever the
% animal licks **and** a BNC input receives high voltage. Typically, this
% is used to deliver reward to the animal when it is in a particular
% location on the treadmill. The reward signal is generally signaled by the
% L&N treadmill system and the location of reward delivery can be
% customized with their code. In addition to delivering reward, this
% function outputs a lick detection signal and a reward delivery signal,
% both of which are sent from the Bpod BNC outputs, which can thus be fed
% into a NI board synchronized with other experimental events. The protocol
% allows for randomly interleaved catch trials in which the reward is not
% delivered.
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Load settings chosen in launch manager
S = BpodSystem.ProtocolSettings;

% Create the GUI with task parameters
S = TreadmillReward_CreateParamGUI(S);

% Create list of trials
MaxRewLoc = 1500;
[TrialTypes, Outcomes] = TreadmillReward_CreateTrialList(S, MaxRewLoc);

% Create online monitoring plots
TreadmillReward_CreatePlots(TrialTypes);

% Loop infinitely over reward locations (a.k.a. laps if there is only one
% reward location per lap)
for iRewLoc = 1:MaxRewLoc
    
    % Update task parameters
    % ~~~~~~~~~~~~~~~~~~~~~~
    
    % Sync parameters with the GUI
    S = BpodParameterGUI('Sync', S);
    
    % Get parameters from the GUI
    param = TreadmillReward_TransformGuiParams(S);
    
    % Update trial list if the reward probability was changed
    if iRewLoc > 1
        TrialTypes = TreadmillReward_UpdateTrialList(S, TrialTypes, iRewLoc, MaxRewLoc);
    end
    
    % Create and send the state machine corresponding to the current lap
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    % Prepare current trial's state machine
    sma = TreadmillReward_PrepareStateMachine(S, param, TrialTypes, iRewLoc);
    
    % Send state machine to the Bpod state machine device
    SendStateMatrix(sma);
    
    % Run the trial and return events
    RawEvents = RunStateMatrix;
    
    % Save data
    % ~~~~~~~~~
    
    % If the session was not manually stooped mid-trial
    if ~isempty(fieldnames(RawEvents))
        
        % Adds raw events to a human-readable data struct
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data, RawEvents);
        
        % Adds the settings used for the current trial to the data
        % structure
        BpodSystem.Data.TrialSettings(iRewLoc) = S;
        
        % Saves the data structure to the current data file
        if S.GUI.Save_data, SaveBpodSessionData; end
        
        % Update the plots
        % ~~~~~~~~~~~~~~~~
        Outcomes = TreadmillReward_UpdatePlots(S, TrialTypes, Outcomes, iRewLoc);
    end
    
    % Checks to see if the protocol is paused. If so, waits until user
    % resumes
    HandlePauseCondition;
    if BpodSystem.Status.BeingUsed == 0, return; end
end

end