function keys = iomethod(iomethod)
%IOMETHOD Summary of this function goes here
%   Detailed explanation goes here


switch iomethod
    
    % Keyboard answer.
    case 0
        keys.keyView=KbName('m'); % key to see
        keys.keyNotView=KbName('z'); % key not see.
        
    % Lumina response box LU400 (A).
    case 1
        keys.keyView = 51;
        keys.keyNotView = 52;
end


end

