load('ci_dfnc.mat');
if dfncInfo.userInput.numOfSub == 172
    dfncInfo.userInput.ica_param_file=[];
    dfncInfo.userInput.numOfSub = 83;
    dfncInfo.TR(1:89)=[];
    dfncInfo.best_lambda(1:89) = [];
    dfncInfo.outputFiles(1:89) = [];
    save('ci_dfnc.mat');
end

output_perss=nan(6,5);