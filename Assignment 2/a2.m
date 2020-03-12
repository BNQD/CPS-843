%% Setup
run('vlfeat-0.9.21/toolbox/vl_setup')

%% Part 1
close all
alpha = 5; beta = 15; gamma = 20;
points = generate_points(alpha, beta, gamma);

figure(1);
scatter3(points(:, 1), points(:, 2), points(:, 3));
rotate3d;

least_squares = [points(:, 1:2), ones(length(points(:, 1)), 1)]\points(:, 3);


ls_func = @(points) least_squares(1) * points(:, 1) + least_squares(2) * points(:, 2);
orig_func = @(points) alpha * points(:, 1) + beta * points(:, 2) + gamma;

ls_error = sum((ls_func(A) - B).^2);
orig_func_error = sum((orig_func(A) - B).^2);

alpha_error = least_squares(1) - alpha;
beta_error = least_squares(2) - beta;
gamma_error = least_squares(3) - gamma;

disp ("Parameter Error in Alpha: " + alpha_error);
disp ("Parameter Error in Beta: " + beta_error);
disp ("Parameter Error in Gamma: " + gamma_error);
%% RANSAC Image Stiching Affine
left_img = single(rgb2gray(imread ('parliament-left.jpg')));
right_img = single(rgb2gray(imread ('parliament-right.jpg')));

[f_left, d_left] = vl_sift(left_img);
[f_right, d_right] = vl_sift(right_img);

distances = dist2(single(d_left)', single(d_right)');
[matched_left, matched_right] = find(distances < 100);

matched_f_left = f_left(:, matched_left);
matched_f_right = f_right(:, matched_right);

%Image 1 * transform = Image 2
%transform = inverse (image 1) * image 2

transform = myRANSAC(matched_f_left, matched_f_right, 0.4, 50);
transform_make = maketform('affine', transform');

left_img_rgb = imread ('parliament-left.jpg');
right_img_rgb = imread ('parliament-right.jpg');

left_r = uint8(imtransform(left_img_rgb(:, :, 1), transform_make));
left_g = uint8(imtransform(left_img_rgb(:, :, 2), transform_make));
left_b = uint8(imtransform(left_img_rgb(:, :, 3), transform_make));

left_rgb_transformed = cat(3, left_r, left_g, left_b);

temp_image = cat(2, left_rgb_transformed, zeros ([2651, 1151, 3]));
v_pos = 195;
h_pos = 1520;
temp_image(v_pos:v_pos-1+size(right_img_rgb, 1), h_pos:size(right_img_rgb, 2)+h_pos-1, :) = right_img_rgb;

figure(2);
imshow(temp_image);

%% RANSAC Homography
rye_left_img = single(rgb2gray(imread ('Ryerson-left.jpg')));
rye_right_img = single(rgb2gray(imread ('Ryerson-right.jpg')));


[f_left, d_left] = vl_sift(rye_left_img);
[f_right, d_right] = vl_sift(rye_right_img);

distances = dist2(single(d_left)', single(d_right)');
[matched_left, matched_right] = find(distances < 1500);

matched_f_left = f_left(:, matched_left);
matched_f_right = f_right(:, matched_right);


transform = myRANSACHomography(matched_f_left, matched_f_right, 2500, 200);
transform = projective2d(transform);

left_img_rgb = imread ('Ryerson-left.jpg');
right_img_rgb = imread ('Ryerson-right.jpg');

left_r = uint8(imwarp(left_img_rgb(:, :, 1), transform));
left_g = uint8(imwarp(left_img_rgb(:, :, 2), transform));
left_b = uint8(imwarp(left_img_rgb(:, :, 3), transform));

left_rgb_transformed = cat(3, left_r, left_g, left_b);

%Image may not stitch exactly, depends on the best transformation found.
temp_image = cat(2, zeros ([size(left_rgb_transformed, 1), 1375, 3]), left_rgb_transformed);
v_pos = 400;
h_pos = 1;

temp_image(v_pos:v_pos-1+size(right_img_rgb, 1), h_pos:size(right_img_rgb, 2)+h_pos-1, :) = right_img_rgb;

figure(3);
imshow(temp_image);
