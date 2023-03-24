%% Prepares corrupted and non-corrupted codewords using the sparse non compact matrix

function [msg, msgEncode, msgEncodeCorrupt] = codeword_gen(numCW)

    % load H matrix
    [~, ~, nonCompactMat, ~] = matrix_prep(648,1296);
    
    % generate messages
    msg = [];
    for m = 1:numCW
        tmp = randi([0, 1], [1, 648]);
        msg = vertcat(msg,tmp);
    end
    
    % encode messages to generate the codewords
    cfgLDPCEnc = ldpcEncoderConfig(sparse(logical(nonCompactMat)));
    msgEncode = ldpcEncode(msg(1,:),cfgLDPCEnc);


    % corrupt messages


    
   
    
    msgCorrupt = [];
    


end

