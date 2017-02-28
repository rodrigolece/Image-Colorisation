function [fake, pixels] = fakeImage(img, n, varargin)

if nargin == 2
    pixels = nColourNodes(img, n);
else
    seed = varargin{1};
    pixels = nColourNodes(img, n, seed);
end

fake = convert2greyscale(img);

for c = 1:3
    colour = img(:,:,c);
    tmp = fake(:,:,c);
    % This two first lines allow us to use linear indexes
    
    tmp(pixels) = colour(pixels);
    fake(:,:,c) = tmp;
end

end