function out = squareError(img, reconstructed)

[k, l, ~] = size(img);

out = sum(sum(sum( (img - reconstructed).^2 ))) / (k*l);

end