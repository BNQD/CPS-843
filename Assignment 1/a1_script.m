disp ("Student A: Bao Doan 500733516");
disp ("Student B: Michael R 500696801");
%% Part 1

%CONVOLUTION

orig_table = [
 [-5,0,0,0,0,0,0,0,0,0],
 [0,0,0,0,0,0,0,0,0,0],
 [0,0,-7,2,1,1,3,0,0,0],
 [0,0,0,1,1,1,1,0,0,0],
 [0,0,0,3,1,1,5,0,0,0],
 [0,0,0,-1,-1,-1,-1,0,0,0],
 [0,0,0,1,2,3,4,0,0,0],
 [0,0,0,0,0,0,0,0,0,0],
 [0,0,0,0,0,0,0,0,0,0]
];
%-----------------Q1 HORIZONTAL DERIVATIVE-------------
horz_conv = [
  [-5, 0, 5 ,0 ,0 ,0 ,0 ,0 ,0 ,0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, -7, 2, 8, -1, 2, -1, -3, 0, 0, 0],
  [0, 0, 0, 1, 1, 0, 0, -1, -1, 0, 0, 0],
  [0, 0, 0, 3, 1, -2, 4, -1, -5, 0, 0, 0],
  [0, 0, 0, -1, -1, 0, 0, 1, 1, 0, 0, 0],
  [0, 0, 0, 1, 2, 2, 2, -3, -4, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];


disp("HORIZONTAL DERIVATIVE");
disp(horz_conv);
%----------------------Q2 GRADIENT MAGNITUDE---------------------
disp("GRADIENT MAGNITUDE USING SOBEL FILTER");
h = fspecial('sobel');
val_1 = sqrt(sum(orig_table(3:5, 2:4) .* h, 'all').^2 + sum(orig_table(3:5, 2:4) .* h', 'all').^2);
val_2 = sqrt(sum(orig_table(3:5, 4:6) .* h, 'all').^2 + sum(orig_table(3:5, 4:6) .* h', 'all').^2);
val_3 = sqrt(sum(orig_table(6:8, 4:6) .* h, 'all').^2 + sum(orig_table(6:8, 4:6) .* h', 'all').^2);
disp("At [2,3]: " + val_1 + " [4,3]: " + val_2 + " [4,6]: " + val_3);

%-------------------Q3 MyConv -----------------------------------
%SEE MyConv.m FUNCTION

%-----------------Q4 COMPARISON IMFILTER--------------------------
input_h = fspecial('gaussian',13,2);
input_img = imread('ryerson.jpg');

myconv_output = MyConv(input_img, input_h);
imfilter_output = imfilter(input_img, input_h', 'same');

difference = sum(abs((myconv_output - imfilter_output)), 'all');
disp("Difference of imfilter vs MyConv: " + difference);
disp ("Total Value of Pixels = " + sum(myconv_output, 'all'));
disp("The difference in outputs is minimal");

figure (3);
imshow (abs(myconv_output - imfilter_output), []);
title ('Difference of MyConv and Imfilter');


%----------------Q5 EXECUTION TIME-------------------------------
fish = imread("ryerson.jpg");
disp ("According to 3-sigma rule, gaussian size = 6*8 = 48 --> 49");

disp("2D CONVOLUTION");
input_h = fspecial('gaussian', 49, 8');
tic
    temp = imfilter(fish, input_h);
toc

one_d_gaussian = fspecial ('gaussian', [49 1], 8);
one_d_2_gaussian = fspecial ('gaussian', [1 49], 8);

disp("TWO 1D CONVOLUTIONS");
tic
    temp = imfilter(fish, one_d_gaussian);
    temp = imfilter(fish, one_d_2_gaussian);
toc

disp ("1D Convolution performed many times faster than 2D Convolution");

%% Part 2
%---------------CANNY EDGE DETECTION----------------------------
fish = imread ('fish.png');
fish_edges = (myCanny(fish, 5, 70));
figure (1);
imshow(fish_edges);

fruit_edges = myCanny(imread('bowl-of-fruit.jpg'), 2, 50);
figure (2);
imshow(fruit_edges);


%----------------SEAM CARVING---------------------------------
%OPEN THE SAVED SEAM CARVED IMAGES - SEAM CARVING TAKES AWHILE TO RUN
% SEE SEAM CARVED IMAGES FOLDER
% 
% img = imread ('fish.png');
% seam_carved_fish = MySeamCarving(img, 350, 450);
% 
% 
% rye_img = imread ('ryerson.jpg');
% rye_carved = MySeamCarving(rye_img, 480, 640);
% 
% rye_carved_2 = MySeamCarving(rye_img, 320, 720);
% 
% teddy = imread ('teddy.jpg');
% teddy_carved = MySeamCarving (teddy, 400, 500);








