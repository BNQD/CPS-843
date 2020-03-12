function out_transform = myRANSACHomography (matched_f_left, matched_f_right, threshold, iterations)
    max_inliers = 0;
    
    
    for i = 1:iterations
        inliers_left = [];
        inliers_right = [];
        count_inliers = 0;
        rand_points = randperm(length(matched_f_left), 4); %3 Random points
        matched_f_left_rand = matched_f_left(1:2, rand_points);
        matched_f_right_rand = matched_f_right(1:2, rand_points);

        %Compute Homography matrix 
        A = [];
        for index = 1:4
            x1 = matched_f_left_rand(1, index);
            y1 =  matched_f_left_rand(2, index);
            x1_prime = matched_f_right_rand(1, index);
            y1_prime = matched_f_right_rand(2, index);
            to_stack = [[x1, y1, 1, 0, 0, 0, -x1 * x1_prime, -y1 * x1_prime, -x1_prime];...
                [0, 0, 0, x1, y1, 1, -x1 * y1_prime, -y1 * y1_prime, -y1_prime]];
            A = [A;to_stack];
        end

        [U, S, V] = svd (A, 0);
        homography = V(:, end);
        homography = reshape(homography, [3 3]);
        
        for j = 1:length(matched_f_left)
            total_distance = sum(matched_f_left(1:3, j)' * homography - matched_f_right(1:3, j)', 'all');
            if (abs(total_distance) < threshold)
                inliers_left = [inliers_left;matched_f_left(1:2, j)];
                inliers_right = [inliers_right;matched_f_right(1:2, j)];
                count_inliers = count_inliers + 1;
            end            
        end
        
        if (count_inliers > max_inliers)
           max_inliers = count_inliers;
           max_transform = homography;
           max_inliers_left = inliers_left;
           max_inliers_right = inliers_right;
        end        
    end
    
    A = []; 
    for index = 1:4
        x1 = matched_f_left_rand(1, index);
        y1 =  matched_f_left_rand(2, index);
        x1_prime = matched_f_right_rand(1, index);
        y1_prime = matched_f_right_rand(2, index);
        to_stack = [[x1, y1, 1, 0, 0, 0, -x1 * x1_prime, -y1 * x1_prime, -x1_prime];...
            [0, 0, 0, x1, y1, 1, -x1 * y1_prime, -y1 * y1_prime, -y1_prime]];
        A = [A;to_stack];
    end
    [U, S, V] = svd (A, 0);
    homography = V(:, end);
    out_transform = reshape(homography, [3 3]);
    
end