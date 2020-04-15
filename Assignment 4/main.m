%%
disp ('Bao Doan 500733516');

%% Convolution
clear variables
clc 
close all

img = rgb2gray(imread ('wallpaper.jpg'));
img = imresize (img, [640 480]);

gaussian_sizes = [3 5 7 13 21 31 41 51 71];

time_taken_conv2 = zeros(length(gaussian_sizes), 1);

for i = 1:length(gaussian_sizes)
   tic
   h = fspecial ('gaussian', gaussian_sizes(i), round(gaussian_sizes(i) / 6));
   temp = conv2(img, h);
   time_taken_conv2(i) = toc;
end

for i = 1:length(gaussian_sizes)
   tic
   h = fspecial ('gaussian', gaussian_sizes(i), round(gaussian_sizes(i) / 6));
   h_freq = fft2(h, size(img, 1), size(img, 2));
   img_freq = fft2(img, size(img, 1), size(img, 2));
   temp = h_freq .* img_freq;
   temp = ifft2(temp);
   time_taken_frequency(i) = toc;
end

figure(1)
hold on;
plot(gaussian_sizes, time_taken_conv2);
plot(gaussian_sizes, time_taken_frequency);
title ('Convolution Times');
legend ('Conv2', 'Frequency Domain');

fprintf ("Conv2 has a increasing trend in terms of computation time whereas multiplimeion in the frequency domain \n" + ...
    "is consistent and does not increase too much as the window size increases. For small window sizes, \n" + ...
    "The initial time taken in the frequency domain is higher than conv2, however, as the window size increases \n" + ...
    "the performance of frequency domain convolution is superior\n");

%% Hybrid Image
me = imresize(rgb2gray(imread ('me.jpg')), [480 640]);

girl = imresize(rgb2gray(imread ('girl.jpg')), [480 640]);
girl = imtranslate(girl, [-25, 10]);

me_freq = fft2(me);
girl_freq = fft2(girl);

sigma = 2;
gaussian_filter = fspecial ('gaussian', sigma*6+1, sigma);
gaussian_filter_freq = fft2(gaussian_filter, 480, 640);


me_g = gaussian_filter_freq .* me_freq;
girl_g = gaussian_filter_freq .* girl_freq;

high_girl = girl_g - girl_freq;
low_me = me_g;

added_freq = high_girl + low_me;
added = uint8(ifft2(added_freq));

figure(2);
imshow (added);
title ('girl');

small_added = imresize(added, 0.2);
figure(3);
imshow(small_added);
title ('me');

%% Optical Flow Esimation - Corridor

%Corridor
orig_img_1 = imread ('Sequences/corridor/bt_0.png');
orig_img_2 = imread ('Sequences/corridor/bt_1.png');

img1 = mat2gray(imresize(orig_img_1, 0.1));
img2 = mat2gray(imresize(orig_img_2, 0.1));
figure(4);
set (gcf, 'Position', [200 200 1300 800])
winsize = [3, 4, 5, 7, 9, 13, 17, 22, 30];
for i = 1:9
    subplot (3, 3, i);
    [u, v, valid] = myFlow (img1, img2, winsize(i), 0.01);
    imshow(flowToColor(cat(3, u, v)));
    title ('Flow Field');
end


figure(5);
[u, v, valid] = myFlow (img1, img2, 9, 0.01);
warped_img2 = myWarp(img2, u, v);

imdiff = abs(warped_img2 - img1);
imshow (imresize(imdiff, 20), []);

fprintf ("By varying the window size, it can be seen that the flow fields are less concise as it occupies a\n" + ...
    "larger area. For instance, as the window size increases, it becomes less clear which parts of the image\n" + ...
    "are moving and which are stationary.\n");


figure(6)
for i = 1:100
    clf
    if mod(i, 2) == 0
        imshow(imresize(warped_img2, 20));
    else
        imshow(imresize(img1, 20));
    end
end

%% Optical Flow Esimation - Sphere

%Corridor
orig_img_1 = rgb2gray(imread ('Sequences/sphere/sphere_0.png'));
orig_img_2 = rgb2gray(imread ('Sequences/sphere/sphere_1.png'));

img1 = mat2gray(imresize(orig_img_1, 0.1));
img2 = mat2gray(imresize(orig_img_2, 0.1));
figure(7);
set (gcf, 'Position', [200 200 1300 800])
winsize = [3, 4, 5, 7, 9, 13, 17, 22, 30];
for i = 1:9
    subplot (3, 3, i);
    [u, v, valid] = myFlow (img1, img2, winsize(i), 0.01);
    imshow(flowToColor(cat(3, u, v)));
end


figure(8);
[u, v, valid] = myFlow (img1, img2, 5, 0.1);
warped_img2 = myWarp(img2, u, v);

imdiff = abs(img1 - warped_img2);
imshow (imresize(imdiff, 20), []);


figure(9)
for i = 1:100
    clf
    if mod(i, 2) == 0
        imshow(imresize(warped_img2, 20));
    else
        imshow(imresize(img1, 20));
    end
end

%% Optical Flow Esimation - Synth

orig_img_1 = imread ('Sequences/synth/synth_0.png');
orig_img_2 = imread ('Sequences/synth/synth_1.png');
scale = 0.5;
img1 = mat2gray(imresize(orig_img_1, scale));
img2 = mat2gray(imresize(orig_img_2, scale));
figure(10);
set (gcf, 'Position', [200 200 1300 800])
winsize = [2, 3, 4, 7, 9, 13, 17, 22, 30];
for i = 1:9
    subplot (3, 3, i);
    [u, v, valid] = myFlow (img1, img2, winsize(i), 0.01);
    imshow(flowToColor(cat(3, u, v)));
    title ('Flow Field');
end


figure(11);
[u, v, valid] = myFlow (img1, img2, 5, 0.01);
warped_img2 = myWarp(img2, u, v);

imdiff = abs(img1 - warped_img2);
imshow (imresize(imdiff, 1/scale), []);


figure(12)
for i = 1:100
    clf
    if mod(i, 2) == 0
        imshow(imresize(warped_img2, 1/scale));
    else
        imshow(imresize(img1, 1/scale));
    end
    
end





%%

for i = [1,3,5,7,9,15]
   disp(i); 
end



values = [1,3,5,7,9,7,34,23]
for i = 1:length(values)
   disp(values(i)); 
end







