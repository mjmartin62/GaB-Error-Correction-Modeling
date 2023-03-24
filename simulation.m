%% Test bed for GaB bit fip decoder implemenation that uses 2 compact H-matrices



%% Prepare Workspace and test codewords (clean and corrupt)
clear all; close all;

% import test codewords from serial code codeword generator
load('codewords_from_serial_clean.mat');

% import test codewords from serial code codeword generator that are corrupted
load('codewords_from_serial_corrupt.mat');

% build test array
codewords_test = vertcat(codewords_from_serial_clean,codewords_from_serial_corrupt);


%% Global Variables in accordance with Serial Code implemenation
M = 648;                % Number of rows in H matrix 
N = 1296;               % Number of columns in H matrix
RowDegree = 8;          % Number of elements in H matrix rows 
ColumnDegree = 4;       % Number of elements in H matrix columns
NbIter = 100;           % Max number of decoder iterations


% Load and prepare H matrices
[mapVN, mapCN, nonCompactMat, sparseMat] = matrix_prep(M,N,RowDegree,ColumnDegree);

%% main() Loop to run the test codewords
for CW = 1:height(codewords_test)

    % Extract a test codeword
    Receivedword = codewords_test(CW,:);

    % The following sections outline the initialization and processing loop that represent CUDA kernels
    
    % ############################# Initialization ########################
    % Initialize the VN nodes using the received codeword
    Decide = Receivedword;

    % Initialize the CN to VN message array to 0's
    NbBranch = M*RowDegree;
    CtoV = zeros(1,NbBranch);

    % ############################# Decoder ###############################
    % Iterative loop for the max number of decoder attempts
    for iter = 1:1:NbIter

        % Initialize the VN to CN message array
        if iter == 1
            VtoC = kernel_01a_VtoC_initialize(Receivedword, ColumnDegree, mapVN, N);
        else
        % Update the VN to CN message array
            VtoC = kernel_01b_VtoC_update(Receivedword, ColumnDegree, mapVN, CtoV, VtoC, N);
        end

        % Calculate CN states and update the CtoV message array
        CtoV = kernel_02_CN_process(CtoV, VtoC, mapCN, M, RowDegree);

        % Calculate VN states
        Decide = kernel_03_VN_process(Decide,Receivedword,CtoV,N,ColumnDegree);


        % Calculate Syndrome for updated codeword [NOTE:  TEMPORARILIY
        % USING NONCOMPACT CALCUATION; NEED TO UPDATE FOR SPEED
        % IMPROVEMENT)
        [testCW,~] = syndrome_non_compact(Decide,nonCompactMat,M,N);
        
        % If updated codeword is valid, break the outer decoder loop
        if testCW == 1
            disp(['codeword ' num2str(CW) ' is valid after ' num2str(iter) ' iterations'])
            break;
        end

    end


    % #####################################################################
    

end

