function [average, red, green, blue] = squareError(img, reconstructed)

[k, l, ~] = size(img);

red = sum(sum( (img(:,:,1) - reconstructed(:,:,1)).^2 )) / (k*l);
green = sum(sum( (img(:,:,2) - reconstructed(:,:,2)).^2 )) / (k*l);
blue = sum(sum( (img(:,:,3) - reconstructed(:,:,3)).^2 )) / (k*l);

average =  (red + green + blue)/3;

end