function [s] = checkAvailableRuns(files)

s=struct();

% Initialize series variable.
s.runIdxPerFile = zeros(length(files),1);

for i=1:length(files)
    % Get series number by filename token
    % (fourth token corresponds to the series)
    toks=split(files{i}, '.');
    
    if numel(toks)<4
        toksRun=split(toks(1), '-');
        tokSeries=toksRun(2);
    else
        tokSeries=toks(4);
    end
    s.runIdxPerFile(i,1) = str2double(tokSeries);
end

% Unique (dicom) files series.
s.sNumbers = unique(s.runIdxPerFile);

% --- Get number of volumes per series ---
s.sVolumes = hist(s.runIdxPerFile,length(1:s.sNumbers(end))); %hist
% Remove series with zero elements.
s.sVolumes = s.sVolumes(s.sVolumes~=0);

end