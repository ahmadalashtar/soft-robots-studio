function value = detectSeparator(app)
    x = app.UIFigure.CurrentPoint(1);
    y = app.UIFigure.CurrentPoint(2);
    
    tabWidth = app.OptimizerTab.Position(3);
    cellWidth = app.GridLayout.ColumnWidth{5};
    
    tabHeight = app.OptimizerTab.Position(4);
    textAreaWidth = app.GridLayout.RowHeight{9};

    VSeparatorWidth = app.GridLayout.ColumnWidth{4};
    HSeparatorHeight = app.GridLayout.RowHeight{8};
    
    rightPadding = app.GridLayout.Padding(3);
    bottomPadding = app.GridLayout.Padding(2);

    rows = app.GridLayout.RowHeight;
    if (x > tabWidth - cellWidth - VSeparatorWidth-rightPadding-5) && (x < tabWidth - cellWidth-rightPadding+5)
        
        value = "Vertical";
        return;
    elseif (y>bottomPadding+textAreaWidth-5) && (y<bottomPadding+textAreaWidth+HSeparatorHeight+5) && (x<tabWidth - cellWidth - VSeparatorWidth-rightPadding)
        
        value = "Horizontal";
        return;
    elseif (y>tabHeight-rows{1}-rows{2}-rows{3}-5) && (y<tabHeight-rows{1}-rows{2}+5) && (x>tabWidth-rightPadding-cellWidth)
        value = "Objects";
        return;
    elseif (y>tabHeight-rows{1}-rows{2}-rows{3}-rows{4}-rows{5}-rows{6}-5) && (y<tabHeight-rows{1}-rows{2}-rows{3}-rows{4}-rows{5}+5) && (x>tabWidth-rightPadding-cellWidth)
        value = "Options";
        return;
    end
    value = "";
end