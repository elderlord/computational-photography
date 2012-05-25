F_nc = imread('DoGSimple.png');
F_ncd = im2double(F_nc);

F_eed = EE(F_ncd);
figure, imshow(F_eed); title('Edge Enhancement');
F_eec = zeros(size(F_ncd));
for x = 1:size(F_eed, 1)
    for y = 1:size(F_eed, 2)
        if F_eed(x, y) == 0
            F_eec(x, y, 1:3) = 0;
        else
            F_eec(x, y, 1:3) = F_ncd(x, y, 1:3);
        end
    end
end
figure, imshow(F_eec); title('Image Combine');