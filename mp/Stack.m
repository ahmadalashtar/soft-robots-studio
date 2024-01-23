classdef Stack < handle
    properties
        data = {};  % Cell array to store stack elements
        top = 0;    % Index of the top element
    end
    
    methods
        % Push an element onto the stack
        function push(obj, element)
            obj.top = obj.top + 1;
            obj.data{obj.top} = element;
        end
        
        % Pop and return the top element from the stack
        function element = pop(obj)
            if obj.is_empty()
                error('Stack is empty.');
            end
            element = obj.data{obj.top};
             obj.data{obj.top} = [];
            obj.top = obj.top - 1;
        end
        
        % Check if the stack is empty
        function isempty = is_empty(obj)
            isempty = (obj.top == 0);
        end
        
        % Get the number of elements in the stack
        function size = get_size(obj)
            size = obj.top;
        end
        
        % Peek at the top element without removing it
        function element = peek(obj)
            if obj.is_empty()
                error('Stack is empty.');
            end
            element = obj.data{obj.top};
        end
        
        % Clear the stack
        function clear(obj)
            obj.data = {};
            obj.top = 0;
        end
    end
end
