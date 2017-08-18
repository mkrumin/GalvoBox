function out = parseMessage(str)

% this function will parse the UDP message received from the master host

% the expected format of the string is
% instruction ExpRef stimDur nPoints ML(1) AP(1) stimPower(1) ML(2) AP(2) stimPower(2) ...
% ... ML(nPoints) AP(nPoints) stimPower(nPoints)

% for instruction 'StimPrepare' the function will parse the rest of the
% parameters, for the rest of instructions will only parse the instruction
% and the ExpRef
%


%% for debugging
% str = 'StimPrepare MK027 45 2 1.7 -2 1 -1.7 -2 1';

%%
C = textscan(str, '%s');
C = C{1};

out = struct;
out.instruction = C{1};
if length(C)>1
    out.ExpRef = C{2};
end
switch lower(out.instruction)
    case 'stimprepare'
        out.stimParams.stimDuration = str2num(C{3});
        nPoints = str2num(C{4});
        out.stimParams.nPoints = nPoints;
        for iPoint = 1:out.stimParams.nPoints
            out.stimParams.ML(iPoint) = str2num(C{3*(iPoint-1)+5});
            out.stimParams.AP(iPoint) = str2num(C{3*(iPoint-1)+6});
            out.stimParams.stimPower(iPoint) = str2num(C{3*(iPoint-1)+7});
        end
    otherwise
        % do nothing, only the instruction is important
end