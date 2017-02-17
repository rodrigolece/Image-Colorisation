function out = nColourNodes(img, n, varargin)

if nargin == 3
    seed = varargin{1};
    rng(seed)
end

[l, k, ~] = size(img);

% randi does allow replacement, instead randperm
out = randperm(k*l, n);

end