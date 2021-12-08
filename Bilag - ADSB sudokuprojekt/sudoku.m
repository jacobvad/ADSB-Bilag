function S = sudoku(M,S)
%[S,Mout] = sodoku(M,[S])
%
%A recursive program that solves 'sodoku' puzzles.
%
%Inputs:  M  partially filled 9x9 matrix with zeros in 'blank' cells
%         S  list of solutions (only used during recursive calls)
%
%Outputs: S  list of solutions
%
%Written by G.M. Boynton, 6/3/05

%If this is the first call, then zero out the solution matrix
if ~exist('S')
    S = zeros([size(M),0]);
end

%find the first blank cell, or zero
firstId = min(find(M(:)==0));
if isempty(firstId)  %If there aren't any zeros, then we have a solution!
    S(:,:,size(S,3)+1) = M;  %save it
else %calculate the list of all valid numbers that can go into this cell
    [i,j] = ind2sub([9,9],firstId);
    for k=1:9  %loop through all 9 possibilities
        ii = (ceil(i/3)-1)*3+1;
        jj = (ceil(j/3)-1)*3+1;
        mm = M(ii:ii+2,jj:jj+2); %these are the indices into the 3x3 block containing that cell
        if sum(M(i,:)==k)==0 & sum(M(:,j)==k)==0 & sum(mm(:)==k)==0  %OK for column, row, and 3x3 block
            M(i,j) = k;  %put this number in,
            S = sudoku(M,S); %and call this function recursively!
        end
    end
end