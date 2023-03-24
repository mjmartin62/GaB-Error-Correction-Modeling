%% Calculates the state of the CN nodes and then assigns these states into the CtoV array

function [CtoV] = kernel_02_CN_process(CtoV, VtoC, mapCN, M, RowDegree)
    
    % Local Variables

    % Debug Code
    CN_track = zeros(1,648);
    
    % initialize index used to access the VtoC array
    idx = 1;
    idx2 = 1;

    % Outer loop iterates down the rows of the H matrix for VN's associated with the particular CN
    for m = 1:1:M
        
        % Initialize the sign of the XOR operation
        % This variable stores the temporary state for the CN
        signe = 0;

        % Inner loop passes along each set of messages intended for the particular CN being processed in the outer loop
        for r = 1:1:RowDegree
            signe = double(xor(signe,VtoC(idx)));
            idx = idx + 1;
        end
        
        % Assign the state of the CN to CtoV message array
        for r = 1:1:RowDegree
            tmpIDX = mapCN((m-1)*RowDegree + r);
            % CtoV(tmpIDX) = signe;
            CtoV(tmpIDX) = double(xor(signe,VtoC(idx2)));
            idx2 = idx2 + 1;
        end

        % Debug code
        CN_track(m) = signe;

    end

end

