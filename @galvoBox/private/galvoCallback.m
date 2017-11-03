function galvoCallback(src, event, obj)

timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
fprintf('[galvoUDP] [%s] Received ''%s'' from %s:%d\n', timeStamp, str, ip, port);

info=parseMessage(str);

% update remote IP to that of the sender
src.RemoteHost = ip;
src.RemotePort = port;

switch info.instruction
    case 'hello'
        % this is just to check communication
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    case 'ExpStart'
        try
            obj.hw = prepareHardware;
        catch e
            fprintf('\nHardware initialization failed with the following message:\n');
            fprintf('%s\n', e.message);
        end
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    case {'ExpEnd', 'ExpInterrupt'}
        releaseHardware(obj.hw);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    case 'StimPrepare'
        prepareNextStim(obj.hw, info.stimParams)
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    case 'StimStart'
        startZapping(obj.hw);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    case 'StimStop'
        stopZapping(obj.hw);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
    otherwise
        fprintf('Unknown instruction : %s\n', info.instruction);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s'' to %s:%d\n', timeStamp, str, ip, port);
        fwrite(src, data);
end

end
%===========================================================
%
