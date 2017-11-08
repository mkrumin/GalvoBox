function galvoCallback(src, event, obj)

t = clock;
obj.nUDPs = obj.nUDPS + 1;
timeStamp = datestr(t, 'yyyy-mm-dd HH:MM:SS.FFF');
ip=src.DatagramAddress;
port=src.DatagramPort;
data=fread(src);
str=char(data');
obj.UDPLog(obj.nUDPs).timeStamp = datenum(t);
obj.UDPLog(obj.nUDPs).msg = str;
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
        obj.startExperiment(info.ExpRef);
        timeStamp = datestr(clock, 'yyyy-mm-dd HH:MM:SS.FFF');
        fprintf('[galvoUDP] [%s] Sending ''%s ...'' to %s:%d\n', timeStamp, info.instruction, ip, port);
        fwrite(src, data);
    case {'ExpEnd', 'ExpInterrupt'}
        obj.stopExperiment;
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
        pause(0.1);
        obj.logCameraFrame;
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
