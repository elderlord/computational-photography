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
    image = origin(originPos(1): winSize(1), originPos(2): winSize(2),:);
        %[origin(originPos(1): winSize(1), originPos(2): winSize(2),:), origin(originPos(1): winSize(1), originPos(2): winSize(2),:);
        %origin(originPos(1): winSize(1), originPos(2): winSize(2),:), origin(originPos(1): winSize(1), originPos(2): winSize(2),:)];
    
    imageSize = size(image);
    
    % process x side
    while imageSize(1) + winSize(1) - originPos(1) + 1 <= multi(1)
        tmp = [image(:,:,:); image(1:winSize(1) - originPos(1) + 1,:,:)];
        imageSize = size(tmp);
        image = tmp;
    end
    if imageSize(1) < multi(1)
        image = [image(:,:,:); image(1:multi(1) - imageSize(1),:,:)];
    end
    
    % process y side
    while imageSize(2) + winSize(2)  - originPos(2) + 1 <= multi(2)
        tmp = [image(:,:,:), image(:,1:winSize(2)  - originPos(2) + 1,:)];
        imageSize = size(tmp);
        image = tmp;
    end
    if imageSize(2) < multi(2)
        image = [image(:,:,:), image(:,1:multi(2) - imageSize(2),:)];
    end
end

