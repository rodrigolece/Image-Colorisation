function out = recolourFake(fake, pixels, func, sigma1, sigma2, p, delta)
% Input:
% fake: the fake problem, a greyscale image with color infomation on pixels
% pixels: a column vector containing the linear indices which have color information
% func: the radial basis function, choose either 'gauss' or ''compact'
% sigma1, sigma2, p: parameters for weighting the interpolation
% delta: regularisation parameter
% 
% Output:
% out: the recoloured image, k times l times 3 with rgb colors expressed in 8 bits


% Parse the input function
switch func
    case 'gauss'
        phi = @(r) exp(-r.^2);
    case 'compact'
        phi = @(r) max(1-r,0).^4.*(4*r-1);
end


[k, l, ~] = size(fake);
n = length(pixels);

[colori, colorj] = ind2sub([k, l], pixels); % convert linear ind to matrix ind


grey = double(fake(:,:,1));
% Recover greyscale in the color pixels
grey(colori, colorj) = round( 0.3*fake(colori,colorj,1) + ...
    0.11*fake(colori,colorj,2) + 0.59*fake(colori,colorj,3) );

% Calculate the restricted kernel
restricted_kernel = eye(n);

[colori, colorj] = ind2sub([k, l], pixels);

for c = 1:n
    idx = (c+1:n)'; % We only fill in below the diagonal
    
    rest_i = colori(idx);
    rest_j = colorj(idx);
    
    col = phi( sqrt( (colori(c) - colori(idx)).^2 + (colorj(c) - colorj(idx)).^2 ) ...
        /sigma1 ) .* ...
        phi( abs(grey(pixels(c)) - grey(pixels(idx))).^p / sigma2 );
    restricted_kernel(idx, c) = col;
end

% Fill in the symmetric entries
restricted_kernel = restricted_kernel + restricted_kernel' - eye(n);

% Calculate coefficients
coeffs = zeros(n, 3);

for s = 1:3
    color = fake(:,:,s);
    color_vector = double(color(pixels));
    coeffs(:,s) = (restricted_kernel + delta*n*eye(n)) \ color_vector;
end

% The full kernel
full_kernel = zeros(k*l, n);
all_pixels = (1:k*l)';
[i, j] = ind2sub([k, l], all_pixels);

for c = 1:n
    % Something intelligent could be used to reuse the entries of the
    % restricted kernel
    col = phi( sqrt( (colori(c) - i).^2 + (colorj(c) - j).^2 )/sigma1 ) ...
        .* phi( abs(grey(pixels(c)) - grey(all_pixels)).^p / sigma2 );
    full_kernel(:, c) = col;
end


% The final result
out = zeros(k, l, 3, 'uint8');

for s = 1:3
    out(:,:,s) = uint8(reshape(round(full_kernel*coeffs(:,s)), k, l));
end

end