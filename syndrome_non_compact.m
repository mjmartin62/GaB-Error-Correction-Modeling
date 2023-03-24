%% Checks if codeword or bit flipped codeword is valid using the full representation matrix

function [testCW,trackCW] = syndrome_non_compact(codeword,nonCompactMat,M,N)
    
    % initialize a tracking vector
    trackCW = zeros(1,M);

    % compute bitwise XOR for each checknode
    for m = 1:M
        % Initialize XOR operation
        synd = 0;
        % Perform the bitwise XOR operation 
        for n = 1:N
            if nonCompactMat(m,n) == 1
                synd = xor(synd,codeword(n));
            end
        end
        % update codeword tracker
        trackCW(m) = synd;
    end

    % perform test to see if the codeword is a valid codeword
    % 1 = Valid codeword
    % 0 = not codeword
    testCW = (sum(trackCW) == 0);

end

