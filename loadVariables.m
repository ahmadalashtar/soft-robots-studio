function loadVariables(opVar,end_points)
   global op;
   if end_points == 0
       op = opVar;
   else
       op.end_points = end_points;
   end
   
end

