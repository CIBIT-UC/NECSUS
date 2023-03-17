files = dir('events');

%%

for f = 1:numel(files)
    
    file = files(f);

    if not(file.isdir)
        % Get filename tokens.
        parts = split(file.name, '_');

        % destination folder.
        dest=fullfile('E:\BIDS_necsus', parts{1}, parts{2}, 'func');

        % source file.
        source=fullfile(file.folder, file.name);

        fprintf('Copy file %s to %s. \n', source, dest)

        % Copy events file to appropriate folder.
        status = copyfile(source, dest);

        fprintf('File copied: %i  . \n', status)
    end

end
