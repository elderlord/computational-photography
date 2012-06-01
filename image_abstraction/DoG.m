function result = DoG( img, sigma_e, sigma_r, tau, phi)
%DoG 是一個強化邊緣線條的方法，這是我改編Jan Eric Kyprianidis <www.kyprianidis.com>的Shader
%code
%   sigma_e : 影響Gaussians的波形
%   sigma_r : 影響線條的寬窄
%   tau     : 影響線條細節的明顯與否(1會產生許多noise)
%   phi     : 影響線條的濃度
    if nargin < 2
        sigma_e = 1.0;
        sigma_r = 1.6;
        tau = 0.99;
        phi = 2.0;
    elseif nargin < 3
        sigma_r = 1.6;
        tau = 0.99;
        phi = 2.0;
    elseif nargin < 4
        tau = 0.99;
        phi = 2.0;
    elseif nargin < 5
        phi = 2.0;
    end;
    img_size = [size(img, 1), size(img, 2)];
    for x = 1:img_size(1, 1)
        for y = 1:img_size(1, 2)
            uv = [x , y];%vec2 uv = gl_FragCoord.xy / img_size;
            twoSigmaESquared = 2.0 * sigma_e * sigma_e;
            twoSigmaRSquared = 2.0 * sigma_r * sigma_r;
            halfWidth = ceil( 2.0 * sigma_r );

            sum = zeros(1, 2);%vec2 sum = vec2(0.0);
            norm = zeros(1, 2);%vec2 norm = vec2(0.0);

            for i = -halfWidth:halfWidth%    for ( int i = -halfWidth; i <= halfWidth; ++i ) {
                for j = -halfWidth:halfWidth%        for ( int j = -halfWidth; j <= halfWidth; ++j ) {       
                    d = sqrt((i*i)+(j*j));% float d = length(vec2(i,j));
                    kernel = [exp(-d * d / twoSigmaESquared ), exp( -d * d / twoSigmaRSquared )];%vec2 kernel = vec2( exp( -d * d / twoSigmaESquared ), exp( -d * d / twoSigmaRSquared ));
                    u = abs(floor((uv(1, 1) + i)));
                    v = abs(floor((uv(1, 2) + j)));
                    if u > 0 && u < img_size(1, 1) && v > 0 &&  v < img_size(1, 2)
                        %Y = 0.299*img(u, v, 1)+0.587*img(u, v, 2)+0.114*img(u, v, 3);
                        %U = 0.436*(img(u, v, 3)-Y/(1-0.114));
                        %V = 0.615*(img(u, v, 1)-Y/(1-0.299));
                        %X = img(u, v, 1) / 100.0;
                        %Y = 0.5 + 0.5 * ( img(u, v, 2) / 127.0 );
                        %Z = 0.5 + 0.5 * ( img(u, v, 3) / 127.0 );
                        L = [img(u, v, 1), img(u, v, 1)];%            vec2 L = texture2D(img, uv + vec2(i,j) / img_size).xx;
                        norm = norm + 2.0 * kernel;%            norm += 2.0 * kernel;
                        sum = [sum(1, 1) + kernel(1, 1) * L(1, 1), sum(1, 2) + kernel(1, 2) * L(1, 2)];%            sum += kernel * L;
                    end
                end%        }
            end%    }
            sum = [sum(1, 1) / norm(1, 1), sum(1, 2) / norm(1, 2)];%    sum /= norm;

            H = 100.0 * (sum(1, 1) - tau * sum(1, 2));%    float H = 100.0 * (sum.x - tau * sum.y);
            %    float edge = ( H > 0.0 )? 1.0 : 2.0 * smoothstep(-2.0, 2.0, phi * H );
            
            %   smoothstep
            %   genType t;  /* Or genDType t; */
            %   t = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0);
            %   return t * t * (3.0 - 2.0 * t);
            
            %   clamp
            %   min(max(x, minVal), maxVal).
            
            edge = 1.0;
            if H < 0.0
                weight = phi * H;
                t = min(max((weight + 2.0) / (2.0 + 2.0), 0.0), 1.0);
                edge = t * t * (3.0 - 2.0 * t);
            end
            result(x, y, 1:3) = [edge, edge, edge];%    gl_FragColor = vec4(vec3(edge), 1.0);
        end
    end
end

