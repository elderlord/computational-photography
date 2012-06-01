function result = CQ( img, nbins, phi_q )
%CQ is color quantization
    if nargin < 2
        nbins = double(8.0);
        phi_q = double(3.4);
    elseif nargin < 3
        phi_q = double(3.4);
    end
    img_size = [size(img, 1), size(img, 2)];
    for x = 1:img_size(1, 1)
        for y = 1:img_size(1, 2)
            %d = [1.0/img_size(1, 1), 1.0/img_size(1, 2)];%vec2 d = 1.0 / img_size;
            c = img(x, y, 1:3);%vec3 c = texture2D(img, uv).xyz;
            color_x = c(1, 1);
            qn = floor(color_x * nbins + 0.5) / nbins;%float qn = floor(c.x * float(nbins) + 0.5) / float(nbins);
            %float qs = smoothstep(-2.0, 2.0, phi_q * (c.x - qn) * 100.0) - 0.5;
            weight =  phi_q * (color_x - qn) * 100.0;
            qs = min(max((weight + 2.0) / (2.0 + 2.0), 0.0), 1.0) - 0.5;
            %float qc = qn + qs / float(nbins);
            qc = qn + qs / nbins;
            result(x, y, 1:3) = [qc, img(x, y, 2), img(x, y, 3)];
            %gl_FragColor = vec4( vec3(qc, c.yz), 1.0 );
        end
    end
end

