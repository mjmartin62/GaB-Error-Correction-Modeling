%% Initializes the message passing array for VN to CN node

function [VtoC] = kernel_01a_VtoC_initialize(Receivedword, ColumnDegree, mapVN, N)
    
    % Initialize VtoC
    VtoC = zeros(1,ColumnDegree*N);
    
        % Outer loop to assign Codeword bit to scattered 4 addresses
       for n = 1:1:N

           for c = 1:1:ColumnDegree
                tmpIDX = (n-1)*ColumnDegree + c;
                loc = mapVN(tmpIDX);
                VtoC(loc) = Receivedword(n);
           end
       end
                
end

