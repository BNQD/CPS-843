% you might want to have as many negative examples as positive examples
n_have = numel(dir('cropped_training_images_notfaces/*.jpg'));
n_want = round(numel(dir('cropped_training_images_faces/*.jpg')) * 0.6);

imageDir = 'images_notfaces';
imageList = dir(sprintf('%s/*.jpg',imageDir));
nImages = length(imageList);

new_imageDir = 'cropped_training_images_notfaces';
mkdir(new_imageDir);

dim = 36;

while n_have < n_want
    rand_img_name = imageList(floor(rand () * nImages) + 1).name;
    rand_img = imread(strcat("images_notfaces/", rand_img_name));
    
    rows = size(rand_img, 1) - dim;
    width = size(rand_img, 2) - dim;
    
    rand_row = floor(rand() * (size(rand_img, 1) - dim)) + 1;
    rand_col = floor(rand() * (size(rand_img, 2) - dim)) + 1;
    
    rand_window = rgb2gray(rand_img (rand_row:rand_row+dim-1, rand_col:rand_col+dim-1, :));
    
    imwrite(rand_window, strcat ('cropped_training_images_notfaces/', int2str(rand_row), ...
        int2str(rand_col), rand_img_name));
    
    n_have = n_have + 1;
end