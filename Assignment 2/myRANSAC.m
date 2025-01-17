function out_transform = myRANSAC (matched_f_left, matched_f_right, threshold, iterations)
    max_inliers = 0;
   
    
    for i = 1:iterations
         inliers_left = [];
        inliers_right = [];
        count_inliers = 0;
        rand_points = randperm(length(matched_f_left), 3); %3 Random points
        matched_f_left_rand = [matched_f_left(1:2, rand_points); [1,1,1]]';
        matched_f_right_rand = matched_f_right(1:2, rand_points);

        affine = matched_f_left_rand\matched_f_right_rand';
        
        for j = 1:length(matched_f_left)
            total_distance = sum([matched_f_left(1:2, j); 1]' * affine - matched_f_right(1:2, j)', 'all');
            if (abs(total_distance) < threshold)
                inliers_left = [inliers_left;[matched_f_left(1:2, j); 1]'];
                inliers_right = [inliers_right;matched_f_right(1:2, j)'];
                count_inliers = count_inliers + 1;
            end            
        end
        
        if (count_inliers > max_inliers)
           max_inliers = count_inliers;
           max_transform = affine;
           max_inliers_left = inliers_left;
           max_inliers_right = inliers_right;
        end        
    end
    
    out_transform = max_inliers_left\max_inliers_right;
    out_transform = [out_transform';[0 0 1]];
    
end