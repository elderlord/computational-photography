function [ result ] = CM( image_origin, image_ee )
%CM is combine two image together
    result = zeros(size(image_origin));
    for x = 1:size(image_ee, 1)
        for y = 1:size(image_ee, 2)
            if image_ee(x, y) == 0
                result(x, y, 1:3) = 0;
            else
                result(x, y, 1:3) = image_origin(x, y, 1:3);
            end
        end
    end
end

