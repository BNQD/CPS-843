function out = myWarp (img, u, v)
    [x, y] = meshgrid(1:size(img,2), 1:size(img,1));
    out = (interp2(double(img), round(x-u), round(y-v), 'linear', 0));
end