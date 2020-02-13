disp ("Student A: Bao Doan 500733516");
disp ("Student B: Michael R 500696801");

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
disp("GRADIENT MAGNITUDE");
disp("At [2,3]: " + 16.55 + " [4,3]: " + 3.16 + " [4,6]: " + 3.29);

%-------------------Q3 MyConv -----------------------------------
%SEE MyConv.m FUNCTION

%-----------------Q4 COMPARISON IMFILTER--------------------------
input_h = fspecial('gaussian',13,2);
input_img = round(rand(13, 13)*10);

myconv_output = MyConv(input_img, input_h);
imfilter_output = imfilter(input_img, input_h);

difference = sum(abs((myconv_output - imfilter_output)), 'all');
disp("Difference of imfilter vs MyConv: " + difference);
disp("The difference in outputs is minimal");


%----------------Q5 EXECUTION TIME-------------------------------
fish = imread("fish.png");


disp("2D CONVOLUTION");
input_h = fspecial('gaussian', 13, 8');
tic
    temp = imfilter(fish, input_h);
toc

one_d_gaussian = fspecial ('gaussian', [13 1], 8);
one_d_2_gaussian = fspecial ('gaussian', [1 13], 8);

disp("TWO 1D CONVOLUTIONS");
tic
    temp = imfilter(fish, one_d_gaussian);
    temp = imfilter(fish, one_d_2_gaussian);
toc

disp ("1D Convolution performed nearly twice as fast as 2D Convolution");
%---------------CANNY EDGE DETECTION----------------------------
fish_edges = (myCanny(fish, 5, 100));
figure (1);
imshow(fish_edges);

fruit_edges = myCanny(imread('bowl-of-fruit.jpg'), 5, 60);
figure (2);
imshow(fruit_edges);


%----------------SEAM CARVING---------------------------------
%OPEN THE SAVED SEAM CARVED IMAGES - SEAM CARVING TAKES AWHILE TO RUN
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








