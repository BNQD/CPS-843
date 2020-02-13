function out = gradMag(img, channel)
    sobel_grad_x = fspecial ('sobel');
    sobel_grad_y = sobel_grad_x';
    
    double_img = double (img(:,:,channel));
    
    grad_x = MyConv(double_img, sobel_grad_x);
    grad_y = MyConv(double_img, sobel_grad_y);
    
    out = uint8(round(sqrt(grad_x.^2 + grad_y.^2)));

end