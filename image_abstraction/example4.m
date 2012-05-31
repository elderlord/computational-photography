
dir = '../picture/';
name = 'build';
sub = 'png';
F_nc = imread([dir, name, '_NC.', sub]);
F_nc = im2double(F_nc);
%F_eed = imread([dir, name, '_DOG.', sub]);
%F_eed = im2double(F_eed);
F_eed = DoG(F_nc, 1.0, 1.6, 0.98, 2.0);
imwrite(F_eed, [dir, name, '_BF_DOG.', sub]);
F_eec = CM(F_nc, F_eed);
imwrite(F_eec, [dir, name, '_CMB.', sub]);
figure, imshow(F_eec); title('Image Combine');