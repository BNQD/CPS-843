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

fprintf ("Conv2 has a increasing trend in terms of computation time whereas multiplication in the frequency domain \n" + ...
    "is consistent and does not increase too much as the window size increases. For small window sizes, \n" + ...
    "The initial time taken in the frequency domain is higher than conv2, however, as the window size increases \n" + ...
    "the performance of frequency domain convolution is superior\n");

%% Hybrid Image
cat = imresize(rgb2gray(imread ('cat.jpg')), [480 640]);
dog = imresize(rgb2gray(imread ('dog.jpg')), [480 640]);

cat_freq = fft2(cat);
dog_freq = fft2(dog);


