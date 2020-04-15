function [u, v, valid] = myFlow (img1, img2, window_length, threshold)
    five_point_gaussian = (1/12) * [-1 8 0 -8 1];
    flipped_fpg = five_point_gaussian(end:-1:1);
    gaussian = fspecial('gaussian', 3, 1);
    
    temporal_derivative_1 = conv2(img1, gaussian, 'same');
    temporal_derivative_2 = conv2(img2, gaussian, 'same');
    
    temp_derv_diff = temporal_derivative_2 - temporal_derivative_1;
    
    spatial_derivative_x = conv2(img1, flipped_fpg, 'same');
    spatial_derivative_y = conv2(img1, flipped_fpg', 'same');
    
    ix_squared = spatial_derivative_x .* spatial_derivative_x;
    iy_squared = spatial_derivative_y .* spatial_derivative_y;
    ix_iy = spatial_derivative_y .* spatial_derivative_x;
    
    ix_squared_sum = conv2(ix_squared, ones(window_length), 'same');
    iy_squared_sum = conv2(iy_squared, ones(window_length), 'same');
    ix_iy_sum = conv2 (ix_iy, ones(window_length), 'same');
    
    ix_it = temp_derv_diff .* spatial_derivative_x;
    iy_it = temp_derv_diff .* spatial_derivative_y;
    
    ix_it_sum = conv2(ix_it, ones(window_length), 'same');
    iy_it_sum = conv2(iy_it, ones(window_length), 'same');
    
    
    valid = zeros(size(img1));
    u = zeros(size(img1));
    v = zeros(size(img1));
    
    for i = 2:size(img1, 1)-1
        for j = 2:size(img1, 2)-1
            left_matrix = [[ix_squared_sum(i, j), ix_iy_sum(i, j)];[ix_iy_sum(i, j), iy_squared_sum(i, j)]];
            if (min(eig(left_matrix)) < threshold)
                valid(i, j) = 0;
                u(i, j) = 0;
                v(i, j) = 0;
            else
                %compute flow
                valid(i, j) = 0.01;
                right_matrix = -[ix_it_sum(i, j);iy_it_sum(i,j)];
                temp = left_matrix\right_matrix;
                u(i, j) = temp(1);
                v(i, j) = temp(2);
                %pause
            end
        end
    end
end