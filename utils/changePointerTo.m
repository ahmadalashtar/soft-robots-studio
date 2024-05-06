function changePointerTo(app,tool)
            if tool=="target" || tool == "eraser"
                            app.UIFigure.Pointer = "custom";
                if tool == "eraser"
                    matrix = [   nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan;
                                 nan nan nan nan nan nan nan nan 1 1 1 1 1 nan nan nan;
                                 nan nan nan nan nan nan nan 1 1 nan nan nan 1 1 nan nan;
                                 nan nan nan nan nan nan 1 1 nan nan nan nan nan 1 1 nan;
                                 nan nan nan nan nan 1 1 nan nan nan nan nan nan nan 1 1;
                                 nan nan nan nan 1 1 nan nan nan nan nan nan nan nan 1 1;
                                 nan nan nan 1 1 1 nan nan nan nan nan nan nan nan nan 1;
                                 nan nan 1 1 nan 1 1 nan nan nan nan nan nan nan 1 1;
                                 nan 1 1 nan nan nan 1 1 nan nan nan nan nan 1 1 nan;
                                 1 1 nan nan nan nan nan 1 1 nan nan nan 1 1 nan nan;
                                 1 nan nan nan nan nan nan nan 1 1 nan 1 1 nan nan nan;
                                 1 nan nan nan nan nan nan nan nan 1 1 1 nan nan nan nan;
                                 1 1 nan nan nan nan nan nan nan 1 1 nan nan nan nan nan;
                                 nan 1 1 nan nan nan nan nan 1 1 nan nan nan nan nan nan;
                                 nan nan 1 1 1 1 1 1 1 1 1 1 1 1 1 1;
                                 nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan;
                             ];
                    app.UIFigure.PointerShapeHotSpot = [16 1];
                    app.latestTool = tool;
                elseif tool == "target"
                    % Create a 16x16 matrix with NaN values
                    matrix = [ nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan
                             nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan
                             nan nan nan nan nan nan nan 1 1 nan nan nan nan nan nan nan
                             nan nan nan nan nan nan nan 1 1 nan nan nan nan nan nan nan
                             nan nan nan nan nan nan nan 1 1 nan nan nan nan nan nan nan
                             nan nan nan nan nan nan 1 1 1 1 nan nan nan nan nan nan
                             nan 1 1 1 1 1 1 nan nan 1 1 1 1 1 1 nan
                             nan nan 1 1 1 nan nan nan nan nan nan 1 1 1 nan nan
                             nan nan nan 1 1 1 nan nan nan nan 1 1 1 nan nan nan
                             nan nan nan nan nan 1 nan nan nan nan 1 nan nan nan nan nan
                             nan nan nan nan nan 1 nan nan nan nan 1 nan nan nan nan nan
                             nan nan nan nan 1 1 1 1 1 1 1 1 nan nan nan nan
                             nan nan nan nan 1 1 1 nan nan 1 1 1 nan nan nan nan
                             nan nan nan nan 1 1 nan nan nan nan 1 1 nan nan nan nan
                             nan nan nan 1 nan nan nan nan nan nan nan nan 1 nan nan nan
                             nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan
                            ];
                    app.UIFigure.PointerShapeHotSpot = [8 8];
                    app.latestTool = tool;
                
         
                end
            app.UIFigure.PointerShapeCData = matrix;
            else 
                app.UIFigure.Pointer = tool;
                app.latestTool = tool;
            end
        end