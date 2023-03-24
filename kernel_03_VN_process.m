%% Calculates the state of the VN nodes 

function [Decide] = kernel_03_VN_process(Decide,Receivedword,CtoV,N,ColumnDegree)
    
    % Local Variables
    % Global
    
    % initialize the bit flip calculation variable
    Global = 1 - 2*Receivedword;

    % Outer loop iterates for each VN update
    for n = 1:1:N
        
        % Inner loop iterates for each CN message set fed into the VN
        for c = 1:1:ColumnDegree
            tmpIDX = (n-1)*ColumnDegree + c;
            Global(n) = Global(n) + (-2)*CtoV(tmpIDX) + 1;
        end

        % Run bit flip operation for the VN in accordance with the outer loop
        if Global(n) > 0
            Decide(n) = 0;
        elseif Global(n) < 0
            Decide(n) = 1;
        else
            Decide(n) = Receivedword(n);
        end


    end

end

