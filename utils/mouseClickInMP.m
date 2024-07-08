function mouseClickInMP(app, src)
    node = app.MPTree.SelectedNodes;
    x = src.UserData.x;
    y = src.UserData.y;
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
    
    
    targetsAndBase = [node.NodeData.targets ; node.NodeData.base];
    speed = app.SpeedperFrame1secto0secSlider.Value;
    secondsToPause = (100-speed)/100;
    for from = 1 : numel(targetsAndBase(:,1))
        if app.previousX == round(targetsAndBase(from,1),3) && app.previousY == round(targetsAndBase(from,2),3)
            for to = 1 : numel(targetsAndBase(:,1))
                if round(x,3) == round(targetsAndBase(to,1),3) && round(y,3) == round(targetsAndBase(to,2),3)
                    app.MPRunning = true;
                        MP_softRobot_animation_2D(app,node.NodeData.paths{from}{to},node.NodeData.base, true, node.NodeData.obstacles, app.UIAxes2,secondsToPause)
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