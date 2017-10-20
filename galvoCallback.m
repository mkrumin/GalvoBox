function galvoCallback(src, event)

persistent hw

ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
fprintf('Received ''%s'' from %s:%d\n', str, ip, port);

info=parseMessage(str);

% update remote IP to that of the sender (port is standard mpep listening
% port as initialised in SIListener.m)
src.RemoteHost = ip;

switch info.instruction
    case 'hello'
        % this is just to check communication
        fwrite(src, data);
    case 'ExpStart'
        hw = prepareHardware;
        fwrite(src, data);
    case {'ExpEnd', 'ExpInterrupt'}
        hw = releaseHardware(hw);
        fwrite(src, data);
    case 'StimPrepare'
        prepareNextStim(hw, info.stimParams)
        fwrite(src, data);
    case 'StimStart'
        startZapping(hw);
        fwrite(src, data);
    case 'StimStop'
        stopZapping(hw);
        fwrite(src, data);
    otherwise
        fprintf('Unknown instruction : %s', info.instruction);
        fwrite(src, data);
end

end
%===========================================================
%
