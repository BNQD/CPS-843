function out = myCanny (img, standard_dev, grad_threshold)

    one_d_gaussian = fspecial ('gaussian', [5 1], standard_dev);
    one_d_2_gaussian = fspecial ('gaussian', [1 5], standard_dev);
    
    img = MyConv(img, one_d_gaussian); 
    img = MyConv(img, one_d_2_gaussian);
    
    sobel_grad_x = fspecial ('sobel');
    sobel_grad_y = sobel_grad_x';
    
    double_img = double (rgb2gray(img));
    
    grad_x = MyConv(double_img, sobel_grad_x);
    grad_y = MyConv(double_img, sobel_grad_y);
    
    gradient_magnitude = uint8(round(sqrt(grad_x.^2 + grad_y.^2)));
    gradient_direction = atan2(grad_y, grad_x);
    
    grad_mag_padded = padarray(gradient_magnitude, [1,1], 'both');
    grad_mag_copy = gradient_magnitude;
    
    for x = 1:size(gradient_direction, 1)
        for y = 1:size(gradient_direction, 2)
            direction = atan_direction(gradient_direction(x, y));
            
            switch direction
                case "Horizontal"
                    max_dir = max ([grad_mag_padded(x,y+1); grad_mag_padded(x+1, y+1); ...
                        grad_mag_padded(x+2, y+1)]);
                case "Vertical"
                    max_dir = max ([grad_mag_padded(x+1, y);grad_mag_padded(x+1, y+1);...
                        grad_mag_padded(x+1, y+2)]);
                case "Diagonal Pos"
                    max_dir = max ([grad_mag_padded(x, y+2);grad_mag_padded(x+1, y+1);...
                        grad_mag_padded(x+2, y)]);
                case "Diagonal Neg"
                    max_dir = max ([grad_mag_padded(x, y);grad_mag_padded(x+1, y+1);...
                        grad_mag_padded(x+2, y+2)]);
                otherwise
                    continue%disp (gradient_direction(x, y));
            end
            if (gradient_magnitude (x, y) ~= max_dir)
                grad_mag_copy (x, y) = 0;
            end
        end
    end
    
    out = grad_mag_copy > grad_threshold;
    
end