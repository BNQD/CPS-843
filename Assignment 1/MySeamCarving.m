function out = MySeamCarving (img, new_x, new_y)
    while (size(img, 1) > new_x)
       img = removeHorizontalSeam(img);
    end
    
    while (size(img, 2) > new_y)
       img = removeVerticalSeam(img);
    end

    out = img;
end