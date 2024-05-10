function value = confirmAction(app,title,msg)
    fig = app.UIFigure;
    selection = uiconfirm(fig,msg,title, ...
        "Options",["OK","Cancel"], ...
        "DefaultOption",2,"CancelOption",2);
    value = selection;

end