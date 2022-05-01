# TreadmillReward

_TreadmillReward_ is a [Bpod](https://sites.google.com/site/bpoddocumentation/) protocol which delivers reward whenever the animal licks _and_ a BNC input receives high voltage. Typically, this is used to deliver reward to the animal when it is in a particular location on the treadmill. The reward signal is generally signaled by the L&N treadmill system and the location of reward delivery can be customized with their code. In addition to delivering reward, this function outputs a lick detection signal and a reward delivery signal, both of which are sent from the Bpod BNC outputs, which can thus be fed into a NI board synchronized with other experimental events. The protocol allows for randomly interleaved catch trials in which the reward is not delivered.

The repository contains two main protocol functions:
- ```TreadmillReward_RunStateMachine```
- ```TreadmillReward_TrialManagerObject```
Both run the exact same protocol, whose states are defined in ```TreadmillReward_PrepareStateMachine```. The ```*RunStateMachine``` version has a simpler syntax but will suffer from dead time after each trial in which the Bpod will fail to monitor events. By contrast, the ```*TrialManagerObject``` will drastically reduce between trials dead time such that is is very unlikely that any events are missed
(see [here](https://sites.google.com/site/bpoddocumentation/user-guide/function-reference/trialmanagerobject?authuser=0)), we thus recomend using this version for data acquisition.

Note also that ```TreadmillReward_RunStateMachine``` can be tested using a Bpod emulator, but not the equivalent ```TreadmillReward_TrialManagerObject```.