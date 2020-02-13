
%----------------CONVOLUTION Q3 CONVOLUTION FUNCTION------------------------
function output = MyConv(img, h)
    %h = rot90(h, 2);
    w = size(h, 1);
    h_ = size(h, 2);
    new_h = (h_-1)/2;
    new_w = (w-1)/2;
    padded = padarray(img, [new_w, new_h], 'both');
    output = img;
    for x = (1:size(img, 1))
        for y =(1:size(img, 2))
            output(x, y) = sum(sum(cast(padded(x:x+w-1, y:y+h_-1), 'double').* h));
        end
    end
end