function [ result ] = CM( image_origin, image_ee )
%CM is combine two image together
    result = zeros(size(image_origin));
    for x = 1:size(image_ee, 1)
        for y = 1:size(image_ee, 2)
            if image_ee(x, y) < 1
                result(x, y, 1:3) = [image_ee(x,y), image_ee(x,y),image_ee(x,y)];
            else
                result(x, y, 1:3) = image_origin(x, y, 1:3);
            end
        end
    end
end

