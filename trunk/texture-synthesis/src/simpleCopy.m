function image = simpleCopy( fileName, originPos, winSize, multi)
%simpleCopy Summary of this function goes here
%   simpleCopy is a function to copy a image with fileName
%   start with originPos
%   end at size
%   and copy power.
    origin = im2Double(imread(fileName));
    oriSize = size(origin);
    
    %check window not out of bound
    for i = 1: 2
        if winSize(i) > oriSize(i)
            winSize(i) = oriSize(i);
        end
    end
    image = [origin(originPos(1): winSize(1), originPos(2): winSize(2),:), origin(originPos(1): winSize(1), originPos(2): winSize(2),:);
        origin(originPos(1): winSize(1), originPos(2): winSize(2),:), origin(originPos(1): winSize(1), originPos(2): winSize(2),:)];
    
    imageSize = size(image);
    
    % process x side
    while imageSize(1) + winSize(1) <= oriSize(1) * multi
        image = [image(:,:,:); image(originPos(1):winSize(1),:,:)];
        imageSize = size(image);
    end
    if imageSize(1) < oriSize(1) * multi
        image = [image(:,:,:), image(originPos(1):oriSize(1) * multi - imageSize(1),:,:)];
    end
    
    % process y side
    %image = [image(:,:,:);image(:,:,:)];
end

