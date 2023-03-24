%% Info
% Prepares mapping H matrices for form compatible with CUDA implemenation
% Creates full H matrix represenation then compresses using 2 different
% intended mapping schemes in terms of promoting linear address mapping
% using coalescne

function [mapVN, mapCN, nonCompactMat, sparseMat] = matrix_prep(M,N,RowDegree,ColumnDegree)

    % load sparse matrix from workspace and index everything by 1 to
    % account for c++ and matlab differences
    sparseMat = double(load('IRISC_dv4_R050_L54_N1296_Dform')) + 1;
    N_compact = width(sparseMat);
    
    % #### create non compact matrix #### 
    % declare non compact matrix
    nonCompactMat = zeros(M,N);
    % populate non compact matrix
    for m = 1:M
        for n = 1:N_compact
            nonCompactMat(m,sparseMat(m,n)) = 1;
        end
    end

    % #### compress non compact matrix to row compact #### 
    mapVN = zeros(1,M*RowDegree);
    % Initialize the index counter offset
    offset = ones(1,M);
    % Initialize nest loop index counter
    idx = 1;
    % 
    for n = 1:1:N
        % 
        for m = 1:1:M
            if nonCompactMat(m,n) == 1
                
                tmpMemLoc = (m-1) * RowDegree + offset(m);
                mapVN(idx) = tmpMemLoc;
                % update the index and offset counters
                idx = idx +1;
                offset(m) = offset(m) + 1;
            end
        end
    end


    % #### compress non compact matrix to column compact #### 
    % Initialize the mapping matrix
    mapCN = zeros(1,N*ColumnDegree);
    % Initialize the index counter offset
    offset = ones(1,N);
    % Initialize nest loop index counter
    idx = 1;
    % loop down the rows of H matrix for CN mapping
    for m = 1:1:M
        % loop across row of H matrix to find where CtoV edge occurs for outer loop CN
        for n = 1:1:N
            if nonCompactMat(m,n) == 1
                tmpMemLoc = (n-1)*ColumnDegree + offset(n);
                mapCN(idx) = tmpMemLoc;
                % update the index and offset counters
                idx = idx +1;
                offset(n) = offset(n) + 1;
            end
        end
    end

    


end

