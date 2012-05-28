function [ result ] = EE( input, th )
%Edge Enhancement
    if( nargin > 1)
        threshold = th';
    else
        threshold = 0.7;
    end;
    
    I = double(input);
    mask=[-1 -1 -1 
          -1  8 -1
          -1 -1 -1];
    result = zeros(size(I, 1), size(I, 2));
    result = conv2(I(1:size(I, 1), 1:size(I, 2), 1), mask, 'same');
    result = result + conv2(I(1:size(I, 1), 1:size(I, 2), 2), mask, 'same');
    result = result + conv2(I(1:size(I, 1), 1:size(I, 2), 3), mask, 'same');
    for i = 1:size(result, 1)
        for j = 1:size(result, 2)
            if result(i, j) < 0 && 1 + tanh(result(i, j)) < threshold
                result(i, j) = 0;
            else
                result(i, j) = 1;
            end
        end
    end
    %imshow(result);
end

