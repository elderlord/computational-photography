function [ result ] = CM( image_origin, image_ee, edge_color )
%CM is combine two image together
    if nargin < 3
        edge_color = [0.0, 0.0, 0.0];
    end
    result = zeros(size(image_origin));
    for x = 1:size(image_ee, 1)
        for y = 1:size(image_ee, 2)
            %if image_ee(x, y) < 1
            %    result(x, y, 1:3) = [image_ee(x,y), image_ee(x,y),image_ee(x,y)];
            %else
            %    result(x, y, 1:3) = image_origin(x, y, 1:3);
            %end
            result(x, y, 1) = edge_color(1, 1)*(1-image_ee(x, y, 1)) + image_origin(x,y,1)*image_ee(x, y,1);
            result(x, y, 2) = edge_color(1, 2)*(1-image_ee(x, y, 1)) + image_origin(x,y,2)*image_ee(x, y,1);
            result(x, y, 3) = edge_color(1, 3)*(1-image_ee(x, y, 1)) + image_origin(x,y,3)*image_ee(x, y,1);
        end
    end
end

