function out = removeVerticalSeam(img)
    %Energy of img
    r_grad_mag = double(gradMag(img, 1));
    g_grad_mag = double(gradMag(img, 2));
    b_grad_mag = double(gradMag(img, 3));

    energy = r_grad_mag + g_grad_mag + b_grad_mag;
    
    scoring_matrix = zeros(size(energy));
    scoring_matrix(:,1,:) = energy(:,1,:);
    
    for row = 2:size(energy, 1)
        for col = 1:size(energy, 2)
            if (row == 1)
               scoring_matrix(row, col) = energy(row, col)...
                   + min(scoring_matrix(row, col), scoring_matrix(row+1, col));
            elseif (row == (size(energy, 1)))
                scoring_matrix(row, col) = energy(row, col) + ...
                    min(scoring_matrix(row, col), scoring_matrix(row-1, col));
            else
               scoring_matrix(row, col) = energy(row, col) + ...
                   min([scoring_matrix(row-1, col),scoring_matrix(row, col), scoring_matrix(row+1, col)]);
            end
           
        end 
    end
    
    [min_val, min_row] = min(energy(size(energy, 1), :));
    %temp = energy(:, size(energy, 1));
    temp = img(size(energy, 1), :, :);
    temp(:, min_row, :) = [];
    out = temp;
   	for current_row = size(energy, 1)-1:-1:1
        if (min_row == 1)
            [min_val, min_row_change] = min(energy(current_row, min_row:min_row+1));
        elseif (min_row == size(energy, 2))
            [min_val, min_row_change] = min(energy(current_row, min_row-1:min_row));
            min_row_change = min_row_change-2;
        else
            [min_val, min_row_change] = min(energy(current_row,min_row-1:min_row+1));
            min_row_change = min_row_change-1;
        end
        temp = img(current_row, :, :);
        min_row = min_row + min_row_change - 1;
        temp(:, min_row, :) = [];
        out = cat(1, temp, out);
    end
    out = uint8 (out);
end