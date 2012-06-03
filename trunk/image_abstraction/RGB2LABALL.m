function result = RGB2LABALL( img )
    img_size = size(img);
    for x = 1:img_size(1, 1)
        for y = 1:img_size(1, 2)
            result(x, y, 1:3) = RGB2LAB(img(x, y, 1:3));
        end
    end
end

function result = RGB2LAB( img )
%rgb2lab change rgb to lab
    lab = XYZ2LAB(RGB2XYZ(img));
    result = [lab(1, 1)/ 100.0, 0.5 + 0.5 * ( lab(1, 2) / 127.0 ), 0.5 + 0.5 * ( lab(1, 3) / 127.0 )];
end

function result = XYZ2LAB(img)
    n(1, 1:3) = [img(1, 1) / 95.047, img(1, 2) / 100, img(1, 3) / 108.883];
    v(1, 1) = ( 7.787 * n(1, 1) ) + ( 16.0 / 116.0 );
    if ( n(1, 1) > 0.008856 )
        v(1, 1) = n(1, 1).^(1.0 / 3.0 );
    end
    v(1, 2) = ( 7.787 * n(1, 2) ) + ( 16.0 / 116.0 );
    if ( n(1, 2) > 0.008856 )
        v(1, 2) = n(1, 2).^( 1.0 / 3.0 );
    end
    v(1, 3) = ( 7.787 * n(1, 3) ) + ( 16.0 / 116.0 );
    if ( n(1, 3) > 0.008856 )
        v(1, 3) = n(1, 3).^( 1.0 / 3.0 );
    end
    result = [( 116.0 * v(1, 2) ) - 16.0, 500.0 * ( v(1, 1) - v(1, 2) ), 200.0 * ( v(1, 2) - v(1, 3))];
end

function result = RGB2XYZ(img)
    tmp(1, 1) =  img(1, 1) / 12.92;
    if(img(1, 1) > 0.04045)
        tmp(1, 1) = ((img(1, 1) + 0.055 ) / 1.055).^2.4;
    end
    tmp(1, 2) =  img(1, 2) / 12.92;
    if(img(1, 2) > 0.04045)
        tmp(1, 2) = ((img(1, 1) + 0.055 ) / 1.055).^2.4;
    end
    tmp(1, 3) =  img(1, 3) / 12.92;
    if(img(1, 3) > 0.04045)
        tmp(1, 3) = ((img(1, 1) + 0.055 ) / 1.055).^2.4;
    end
    mat3 = [0.4124, 0.3576, 0.1805;0.2126, 0.7152, 0.0722;0.0193, 0.1192, 0.9505];
    result =  100.0 * tmp * mat3;
end
