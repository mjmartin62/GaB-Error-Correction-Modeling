%% Corrupts a file set of known good codewords

clear all; close all;

% import test codewords from serial code codeword generator
codewords_from_serial_clean = load('codewords_test.txt');

% temporary storage
codewords_from_serial_corrupt = [];

% bit flip rates
bf_rate = (10:10:200);

for m = 1:height(codewords_from_serial_clean)
    cwTmp = codewords_from_serial_clean(m,:);
    locs = randperm(1296,bf_rate(m));
    
    for n = locs
        cwTmp(n) = double(xor(cwTmp(n),1));
    end

    codewords_from_serial_corrupt = vertcat(codewords_from_serial_corrupt,cwTmp);
end

% save clean and corrupted codewords in .mat
save('codewords_from_serial_corrupt','codewords_from_serial_corrupt');
save('codewords_from_serial_clean','codewords_from_serial_clean')

