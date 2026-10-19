load('ci_dfnc.mat');
if dfncInfo.userInput.numOfSub == 172
    dfncInfo.userInput.ica_param_file=[];
    dfncInfo.userInput.numOfSub = 44;
    ix=ix20;
    dfncInfo.TR(1:89)=[];
    dfncInfo.TR(ix)=[];    
    dfncInfo.best_lambda(1:89) = [];
    dfncInfo.best_lambda(ix) = [];
    dfncInfo.outputFiles(1:89) = [];
    dfncInfo.outputFiles(ix) = [];
    save('ci_dfnc.mat');
end

output_perss=nan(6,5);