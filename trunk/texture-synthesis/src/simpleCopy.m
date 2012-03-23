function image = simpleCopy( fileName, originPos, size)
%simpleCopy Summary of this function goes here
%   simpleCopy is a function to copy a image with fileName
%   start with originPos
%   end at size
%   and copy power.
    origin = imread(fileName);
    doubleOrigin = im2Double(origin);
    image = [doubleOrigin(originPos(1): size(1), originPos(2): size(2),:), doubleOrigin(originPos(1): size(1), originPos(2): size(2),:); doubleOrigin(originPos(1): size(1), originPos(2): size(2),:), doubleOrigin(originPos(1): size(1), originPos(2): size(2),:)];
end

