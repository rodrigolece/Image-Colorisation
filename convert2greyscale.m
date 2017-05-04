function out = convert2greyscale(img)

% grey = round( 0.3*img(:,:,1) + 0.11*img(:,:,2) + 0.59*img(:,:,3) );
% round is not necessary because multiplication and addition preserve uint8
grey = 0.3*img(:,:,1) + 0.11*img(:,:,2) + 0.59*img(:,:,3);

% Matlab loads images in uint8 format. imshow only works correctly if this
% is preserved so the line below cannot be used.
% out = zeros(size(img));

out(:,:,1) = grey;
out(:,:,2) = grey;
out(:,:,3) = grey;

end
