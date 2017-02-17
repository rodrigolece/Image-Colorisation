function out = fakeImage(img, n, varargin)

if nargin == 2
    nodes = nColourNodes(img, n);
else
    seed = varargin{1};
    nodes = nColourNodes(img, n, seed);
end

out = convert2greyscale(img);

for c = 1:3
    colour = img(:,:,c);
    tmp = out(:,:,c);
    % This two first lines allow us to use linear indexes
    
    tmp(nodes) = colour(nodes);
    out(:,:,c) = tmp;
end

end