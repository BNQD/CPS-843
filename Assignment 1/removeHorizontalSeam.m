function out = removeHorizontalSeam(img)
    %Energy of img
    r_grad_mag = double(gradMag(img, 1));
    g_grad_mag = double(gradMag(img, 2));
    b_grad_mag = double(gradMag(img, 3));

    energy = r_grad_mag + g_grad_mag + b_grad_mag;
    
    scoring_matrix = zeros(size(energy));
    scoring_matrix(:,1,:) = energy(:,1,:);
    
    for row = 2:size(energy, 1)
        for col = 1:size(energy, 2)
            if (col == 1)
               scoring_matrix(row, col) = energy(row, col)...
                   + min(scoring_matrix(row, col), scoring_matrix(row, col+1));
            elseif (col == (size(energy, 2)))
                scoring_matrix(row, col) = energy(row, col) + ...
                    min(scoring_matrix(row, col), scoring_matrix(row, col-1));
            else
               scoring_matrix(row, col) = energy(row, col) + ...
                   min([scoring_matrix(row, col-1),scoring_matrix(row, col), scoring_matrix(row, col+1)]);
            end
           
        end
    end
    
    [min_val, min_row] = min(energy(:, size(energy, 2)));
    %temp = energy(:, size(energy, 1));
    temp = img(:, size(energy, 2), :);
    temp(min_row, :, :) = [];
    out = temp;
   	for current_row = size(energy, 2)-1:-1:1
        if (min_row == 1)
            [min_val, min_row_change] = min(energy(min_row:min_row+1, current_row));
        elseif (min_row == size(energy, 1))
            [min_val, min_row_change] = min(energy(min_row-1:min_row, current_row));
            min_row_change = min_row_change-2;
        else
            [min_val, min_row_change] = min(energy(min_row-1:min_row+1, current_row));
            min_row_change = min_row_change-1;
        end
        temp = img(:, current_row, :);
        min_row = min_row + min_row_change - 1;
        temp(min_row, :, :) = [];
        out = cat(2, temp, out);
    end
    out = uint8 (out);
end