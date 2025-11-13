function docInterface = custom_myexcelresults
% custom_myexcelresults - Example custom document interface for
% connecting to a custom written MATLAB test script

    
    docInterface = ReqMgr.LinkableType;

    %%%%%%%%%%%%%%
    % ATTRIBUTES %
    %%%%%%%%%%%%%%
    
    docInterface.Registration = mfilename;
    docInterface.Label = 'Excel Results';

    docInterface.IsFile = 1;
    docInterface.Extensions = {'.xls', '.xlsx'};
    docInterface.LocDelimiters = '@';
    
    %%%%%%%%%%%
    % METHODS %
    %%%%%%%%%%%
    
    % Implementation for NavigateFcn must be provided, see example below.
    docInterface.NavigateFcn = @NavigateFcn;
    docInterface.GetResultFcn = @GetResultFcn;
    
end

%% function NavigateFcn(DOCUMENT, LOCATION)
    % Open 'document' and highlight or zoom into 'location'
function NavigateFcn(document, location)
    disp([mfilename ': Navigating to ' location ' in ' document]);
end

function result = GetResultFcn(link)
    testID = link.destination.id;
    resultFile = link.destination.artifact;
    
    if ~isempty(resultFile) && exist(resultFile, 'file') == 2
        resultTable = readtable(resultFile);
        testRow = strcmp(resultTable.Test,testID);
        status = resultTable.Status(testRow);
        
        if status{1} == "passed"
            result.status = slreq.verification.Status.Pass;
        elseif status{1} == "failed"
            result.status = slreq.verification.Status.Fail;
        else
            result.status = slreq.verification.Status.Unknown;
        end
    else
        result.status = slreq.verification.Status.Unknown;
    end
end