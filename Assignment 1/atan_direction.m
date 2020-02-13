function direction = atan_direction(val)
    if (val < 0)
        val = val + 8;
    end
    
    val = round(val / pi * 4); %Normalize to range 0 - 8
    switch val
        case 1
            direction = "Diagonal Pos";
        case 5
            direction = "Diagonal Pos";
        case 2
            direction = "Vertical";
        case 6
            direction = "Vertical";
        case 3
            direction = "Diagonal Neg";
        case 7
            direction = "Diagonal Neg";
        case 4
            direction = "Horizontal";
        case 0
            direction = "Horizontal";
        case 8
            direction = "Horizontal";
        otherwise
            direction = "Undefined";
    end
    
    
end