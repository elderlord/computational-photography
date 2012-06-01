function result = LAB2RGBALL( img )
%LAB2RGB Lab to RGB
    %img_size = size(img);
    %for x = 1:img_size(1, 1)
    %    for y = 1:img_size(1, 2)
    %        c(1, 1) = min(max(img(x, y, 1), 0.0), 1.0);
    %        c(1, 2) = min(max(img(x, y, 2), 0.0), 1.0);
    %        c(1, 3) = min(max(img(x, y, 3), 0.0), 1.0);
    %        rc(1, 1:3) = LAB2RGB(c);
    %        result(x, y, 1) = min(max(rc(1, 1), 0.0), 1.0);
    %        result(x, y, 2) = min(max(rc(1, 2), 0.0), 1.0);
    %        result(x, y, 3) = min(max(rc(1, 3), 0.0), 1.0);
    %    end
    %end
    
            c(1, 1) = min(max(img(1, 1), 0.0), 1.0);
            c(1, 2) = min(max(img(1, 2), 0.0), 1.0);
            c(1, 3) = min(max(img(1, 3), 0.0), 1.0);
            rc(1, 1:3) = LAB2RGB(c);
            result(1, 1) = min(max(rc(1, 1), 0.0), 1.0);
            result(1, 2) = min(max(rc(1, 2), 0.0), 1.0);
            result(1, 3) = min(max(rc(1, 3), 0.0), 1.0);
end

function result = LAB2RGB( img )
   result(1, 1:3) = XYZ2RGB( LAB2XYZ([100.0 * img(1, 1), 2.0 * 127.0 * (img(1, 2) - 0.5), 2.0 * 127.0 * (img(1, 3) - 0.5)]));  
end

function result = XYZ2RGB( img)
    mat3 = [3.2406, -1.5372, -0.4986; -0.9689, 1.8758, 0.0415;0.0557, -0.2040, 1.0570];
    v =  img / 100.0 * mat3;
    
    r(1, 1) = 12.92 * v(1, 1);
    if(v(1, 1) > 0.0031308)
        r(1, 1) = 1.055 * ( v(1, 1).^( 1.0 / 2.4 ) - 0.055);
    end
    r(1, 2) = 12.92 * v(1, 2);
    if(v(1, 2) > 0.0031308)
        r(1, 2) = 1.055 * ( v(1, 2).^( 1.0 / 2.4 ) - 0.055);
    end
    r(1, 3) = 12.92 * v(1, 3);
    if(v(1, 3) > 0.0031308)
        r(1, 3) = 1.055 * ( v(1, 3).^( 1.0 / 2.4 ) - 0.055);
    end
    result(1, 1:3) =  r(1, 1:3);
end

function result = LAB2XYZ( img)
    fy = ( img(1, 1) + 16.0 ) / 116.0;
    fx = (img(1, 2)) / 500.0 + fy;
    fz = fy - img(1, 3) / 200.0;
    result(1, 1) = ( fx - 16.0 / 116.0 ) / 7.787;
    if fx > 0.206897
        result(1, 1) = fx * fx * fx ;
    end
    result(1, 2) = ( fy - 16.0 / 116.0 ) / 7.787;
    if fx > 0.206897
        result(1, 2) = fy * fy * fy ;
    end
    result(1, 3) = ( fz - 16.0 / 116.0 ) / 7.787;
    if fx > 0.206897
        result(1, 3) = fz * fz * fz ;
    end
    result(1, 1) = result(1, 1) * 95.047;
    result(1, 2) = result(1, 2) * 100.000;
    result(1, 3) = result(1, 3) * 108.883;
end