function mouseClickInMP(app, src, tree, total)
    node = app.MPTree.SelectedNodes;
    if ~tree  
        x = src.UserData.x;
        y = src.UserData.y;
    else
        x = src.NodeData(1);
        y = src.NodeData(2);
    end
    if ~isempty(app.previousX)
        if app.previousX == x && app.previousY == y
            return
        end
    else
        app.previousX = round(node.NodeData.base(1),3);
        app.previousY = round(node.NodeData.base(2),3);
    end

    toggleUI(app,"off",[])
    if app.MPRunning
        return
    end
    
    
    targetsAndBase = [node.NodeData.targets(:, 1:3) ; node.NodeData.base];
    speed = app.SpeedperFrame1secto0secSlider.Value;
    secondsToPause = (100-speed)/100;
    for from = 1 : numel(targetsAndBase(:,1))
        if app.previousX == round(targetsAndBase(from,1),3) && app.previousY == round(targetsAndBase(from,2),3)
            for to = 1 : numel(targetsAndBase(:,1))
                if round(x,3) == round(targetsAndBase(to,1),3) && round(y,3) == round(targetsAndBase(to,2),3)
                    app.MPRunning = true;
                        speed = app.SpeedperFrame1secto0secSlider.Value;
                        secondsToPause = (100-speed)/100;
                        animate_2D(app, app.sp,node.NodeData.paths{from}{to}, [250, 250], secondsToPause, app.UIAxes2);
                    break;
                end
            end
        end
    end

    app.MPRunning = false;
    if app.genHold ~= -10
        toggleUI(app,"on",[app.Stop,app.Pauser])
        buttons = findall(app.TabGroup2, 'Tag', 'robotPara');
        for k = 1:length(buttons)
            buttons(k).Enable = 'off';
        end
    else
        toggleUI(app,"on",[app.Stop, app.Pauser, app.Continuar])
    end

    
    app.previousX = round(x,3);
    app.previousY = round(y,3);
end