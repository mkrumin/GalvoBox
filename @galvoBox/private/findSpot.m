function [x, y] = findSpot(frame)

if length(frame)==Inf
    % if the input argment is axes handle
    ax = frame;
    axes(ax);
    [x, y, button] = ginput(1);
    if button ~= 1
        % if not left mouse button
        % use it if it is difficult to fins the spot
        x = NaN;
        y = NaN;
    end
    
else
    % if input argument is a snapshot 
    % automatic
    frame = imgaussfilt(double(frame), 3);
    frame = frame/max(frame(:));
    p = regionprops(frame>0.8, 'centroid');
    x = p.Centroid(1);
    y = p.Centroid(2);
    
    % manual
%     h = figure;
%     axis equal tight
%     [x, y, button] = ginput(1);
%     
%     if button ~= 1
%         % if not left mouse button
%         % use it if it is difficult to fins the spot
%         x = NaN;
%         y = NaN;
%     end
%     
%     close(h)
end
