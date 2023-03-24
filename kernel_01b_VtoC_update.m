%% Updates the message passing array for VN to CN node

function [VtoC] = kernel_01b_VtoC_update(Receivedword, ColumnDegree, mapVN, CtoV, VtoC, N)
    

    % Initialize local Global variable
    Global = 1 - 2*Receivedword;
    
    % Outer loop iteration for each VN
    for n = 1:1:N
        
        % Inner loop calcuates the state of each VN

        % Initialize the bit state
        for c = 1:1:ColumnDegree
            tmpIDX = (n-1)*ColumnDegree + c;
            
            Global(n) = Global(n) + (-2)*CtoV(tmpIDX) + 1;        
        end

        % Update the VtoC array by scattering the results for VN in this
        % main loop.  Mapping promotes global coalesence reads on
        % subsequent global reads from other kernels.
        for c = 1:1:ColumnDegree
            tmpIDX = (n-1)*ColumnDegree + c;
            buf = Global(n) - ((-2)*CtoV(tmpIDX) + 1);
            
            % Run bit flip logic
            loc = mapVN(tmpIDX);
            if buf < 0
                VtoC(loc) = 1;
            elseif buf > 0
                VtoC(loc) = 0;
            else
                VtoC(loc) = Receivedword(n);
            end
        
        end

    end

end

