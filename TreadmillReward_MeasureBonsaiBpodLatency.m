% This script measures the delay between when an LED light is turned on and
% when it is detected by Bonsai.
% N.B.1 make sure you use the 'develop' branch of Bpod
% N.B.2 make sure you use an exposure time (in the camera acquisition
% software) shorter than the camera frame rate (which should be fast)
% 
% Maxime Maheu, (C)opyright 2022

% Declare global variable which can be accessed outside this function
global BpodSystem;

% Clear data from previous session
BpodSystem.Data = [];

% Define the number of measures to perform
nTest = 500;

% Define the temporal inteval between trials
ISI = 0.1; % second

% Create figure
figure('Color', 'w'); axis; hold('on');
xlabel('Measure ID'); ylabel('Delay [ms]');

% Loop over measurements
delay = NaN(1,nTest);
for iTest = 1:nTest
    
    % Create a new state matrix
    sma = NewStateMatrix();
    
    % Add a sate in which nothing happens for a short period of time
    sma = AddState(sma, 'Name', 'PreTrialTimeOut', ...
        'Timer', ISI,...
        'StateChangeConditions', {'Tup', 'WaitForBonsai'},...
        'OutputActions', {});
    
    % Turn on the light and wait for Bonsai to detect it
    sma = AddState(sma, 'Name', 'WaitForBonsai', ...
        'Timer', 0,...
        'StateChangeConditions', {'SoftCode1', 'BonsaiDetected'},...
        'OutputActions', {'LED', 1});
    
    % Once Bonsai has detected the light, turn off the light and move to
    % the next measurement
    sma = AddState(sma, 'Name', 'BonsaiDetected', ...
        'Timer', 0,...
        'StateChangeConditions', {'Tup', 'exit'},...
        'OutputActions', {'LED', 0});
    
    % Send state machine to the Bpod state machine device
    SendStateMatrix(sma);
    
    % Run the trial and return events
    RawEvents = RunStateMatrix;
    
    % If the session was not manually stooped mid-trial
    if ~isempty(fieldnames(RawEvents))
        
        % Adds raw events to a human-readable data struct
        BpodSystem.Data = AddTrialEvents(BpodSystem.Data, RawEvents);
        
        % Measure timing
        data = BpodSystem.Data.RawEvents.Trial{iTest}.States.WaitForBonsai;
        delay(iTest) = (data(2) - data(1)) * 1000;
        
        % Plot data in real time
        plot(iTest, delay(iTest), 'ko'); drawnow;
        xlim([0,nTest+1]);
    end
end
