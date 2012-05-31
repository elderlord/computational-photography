dir = '../picture/';
name = 'flower';
sub = 'png';

I = imread([dir, name, '.', sub]);
I = im2double(I);
sigma_s = 60;
sigma_r = 0.4;
F_nc = NC(I, sigma_s, sigma_r);
figure, imshow(I); title('Input photograph');
figure, imshow(F_nc); title('Normalized convolution');
imwrite(F_nc, [dir, name, '_NC.', 'png']);
F_eed = DoG(F_nc, 1.0, 1.6, 0.99, 2.0);
imwrite(F_eed, [dir, name, '_DOG.', 'png']);
figure, imshow(F_eed); title('Edge Enhancement');
F_eec = CM(F_nc, F_eed);
imwrite(F_eec, [dir, name, '_CMB.', 'png']);
figure, imshow(F_eec); title('Image Combine');