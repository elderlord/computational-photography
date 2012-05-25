function [ result ] = EE( input )
%Edge Enhancement
    I = double(input);
    mask=[-1 -1 -1 
          -1  8 -1
          -1 -1 -1];
    disp(mask);

    %for i = 1:3
    %    result = result + (0.33 - conv2(I(1:size(I, 1), 1:size(I, 2), i), mask, 'same'));
    %end
    result = zeros(size(I, 1), size(I, 2));
    result = conv2(I(1:size(I, 1), 1:size(I, 2), 1), mask, 'same');
    result = result + conv2(I(1:size(I, 1), 1:size(I, 2), 2), mask, 'same');
    result = result + conv2(I(1:size(I, 1), 1:size(I, 2), 3), mask, 'same');
    for i = 1:size(result, 1)
        for j = 1:size(result, 2)
            if result(i, j) < 0.1 && result(i, j) > -0.1
                result(i, j) = 1;
            else
                result(i, j) = 0;
            end
        end
    end
    imshow(result);
end

