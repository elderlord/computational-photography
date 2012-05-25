F_nc = imread('DoGSimple.png');
F_ncd = im2double(F_nc);

F_eed = EE(F_ncd);
%F_ee = double2im(F_eed);
%figure, imshow(F_ee); title('Edge Enhancement');
%    for i = 1:3
%        F_eec(1:size(F_nc, 1), 1:size(F_nc, 2), i) = F_nc(1:size(F_nc, 1), 1:size(F_nc, 2), i) - F_ee;
%    end
%figure, imshow(F_eec); title('Image Combine');