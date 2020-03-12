function out = generate_points (alpha, beta, gamma)
    temp = rand([500 2]) - 0.5;
    x = temp(:, 1);
    y = temp(:, 2);
    z = alpha .* x + beta .* y + gamma;
    z = z + normrnd((alpha+beta)/20, ((alpha+beta)/20), [500 1]);
    out = cat(2, x, y, z);
    
    
end