function logData(src, event)

global phd t

% plot(event.TimeStamps, event.Data)
% do nothing

phd = event.Data;
t = event.TimeStamps;