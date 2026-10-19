%% Here is how to run the pipeline:

% 0- Go inside each folder corresponding to each scale, e.g., 'SSB*', 
% and execute steps 1 to 6 as follows:

% 1– Type "gift" and run ICA (use NeuroMark as spatial prior) to extract ICs
% 2– Use dfnc toolbox within GIFT and run SSB+SWPC (dFNC method)
% 3- Then, type 'pre'
% 4– Return dfnc toolbox and run k-means (sqEuclidean)
% 5- Conduct visual inspections to identify two extreme states
% 6– Navigate to each directory and edit SSB*.m file, and edit two variables: 
% the 'ps' and the 'ts' corresponding to persnstent and transient state numbers 
% 6- After completing editing across folders, return to the main folder (dfnc) and type 'rn'
% 7– Navigate to the 'fd/rp' directory and run 'main.m' to identify the subjects to exclude
% based on the threshold specified in ix20.mat
% 8– Navigate to the 'fd/sens' directory and type 'rn' command