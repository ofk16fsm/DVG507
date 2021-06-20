function l = tracevisibilityline(rx,ry,tx,ty,e,c)
    % Assume elevation grid and color grid of same size. Assume rx/ry and
    % tx/ty are within the bounds of the grid
    
    height_offset = 25.0;
    max_slope = -100000000000;
    if abs(tx-rx) > abs(ty-ry)
        ns = abs(tx-rx);
    else
        ns = abs(ty-ry);
    end
    
    px = linspace(rx,tx,ns+1);
    py = linspace(ry,ty,ns+1);
    
    % rx/ry is obviously visible
    c(int16(rx),int16(ry)) = 250;
    % Store height at reference position
    rz = e(int16(rx), int16(ry)) + height_offset;
    i = 1;
    while i < ns
        i = i + 1;
        % Determine current height at px/py
        h = e(int16(py(i)), int16(px(i)));
        % Calculate distance D from R
        dx = px(i)-rx;
        dy = py(i)-ry;
        D = sqrt(dx*dx+dy*dy);
        %Calculate current slope
        slope = (h-rz)/D;
        if slope > max_slope
            c(int16(py(i)), int16(px(i))) = 250;
            max_slope = slope;
        else
            c(int16(py(i)), int16(px(i))) = 10;
        end
    end
    l = c;
end