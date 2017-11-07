function galvoCallback(src, event, obj)

timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
fprintf('[galvoUDP] [%s] Received \n%sfrom %s:%d\n', timeStamp, str, ip, port);

try
    info=parseMessage(str);
catch
    info.instruction = 'Failed to parse';
end

% update remote IP to that of the sender
src.RemoteHost = ip;
src.RemotePort = port;

switch info.instruction
    case 'hello'
        % this is just to check communication
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case 'ExpStart'
        try
            if ~isvalid(obj.hw.s)
                obj.prepareHardware;
            end
        catch e
            fprintf('\nHardware initialization failed with the following message:\n');
            fprintf('%s\n', e.message);
        end
        obj.ExpRef = info.ExpRef;
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case {'ExpEnd', 'ExpInterrupt'}
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case 'ZapPrepare'
        obj.prepareNextStim(info)
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case 'ZapStart'
        obj.startZapping;
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case 'ZapStop'
        obj.stopZapping;
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    otherwise
        fprintf('Unknown instruction : %s\n', info.instruction);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
end

end
%===========================================================
%
