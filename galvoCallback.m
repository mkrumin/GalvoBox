function galvoCallback(u)

persistent hw

ip=u.DatagramAddress;
port=u.DatagramPort;
data=fread(u);
str=char(data');
fprintf('Received ''%s'' from %s:%d\n', str, ip, port);

info=parseMessage(str);

% update remote IP to that of the sender (port is standard mpep listening
% port as initialised in SIListener.m)
u.RemoteHost = ip;

switch info.instruction
    case 'hello'
        % this is just to check communication
        fwrite(u, data);
    case 'ExpStart'
        hw = prepareHardware;
        fwrite(u, data);
    case {'ExpEnd', 'ExpInterrupt'}
        hw = releaseHardware(hw);
        fwrite(u, data);
    case 'StimPrepare'
        prepareNextStim(hw, info.stimParams)
        fwrite(u, data);
    case 'StimStart'
        startZapping(hw);
        fwrite(u, data);
    case 'StimStop'
        stopZapping(hw);
        fwrite(u, data);
    otherwise
        fprintf('Unknown instruction : %s', info.instruction);
        fwrite(u, data);
end

end
%===========================================================
%
