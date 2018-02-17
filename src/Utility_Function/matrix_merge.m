function new_matrix = matrix_merge(old_matrix,new_matrix)

old_columns = size(old_matrix,2);
old_rows = size(old_matrix,1);
new_columns = size(new_matrix,2);
new_rows = size(new_matrix,1);

if (old_columns ~= new_columns) 
    error('The number of columns between matrices does not match');
end

if(old_rows ~= new_rows)
    error('The number of rows between matrices does not match');
end

for r = 1:new_rows
    for c = 1:new_columns
       new_matrix(r,c) = old_matrix(r,c);
    end
end