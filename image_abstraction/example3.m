img = imread('../picture/statue.png');
img = im2double(img);
sigma_e = 1.0;
sigma_r = 1.0;
tau = 1.0;
phi = 0.5;
img_size = [size(img, 1), size(img, 2)];
%vec2 uv = gl_FragCoord.xy / img_size;
twoSigmaESquared = 2.0 * sigma_e * sigma_e;
twoSigmaRSquared = 2.0 * sigma_r * sigma_r;
halfWidth = ceil( 2.0 * sigma_r );

sum = zeros(1, 2);%vec2 sum = vec2(0.0);
norm = zeros(1, 2);%vec2 norm = vec2(0.0);

%    for ( int i = -halfWidth; i <= halfWidth; ++i ) {
%        for ( int j = -halfWidth; j <= halfWidth; ++j ) {
d = 1;%            float d = length(vec2(i,j));
                
kernel = [exp(-d * d / twoSigmaESquared ), exp( -d * d / twoSigmaRSquared )];%vec2 kernel = vec2( exp( -d * d / twoSigmaESquared ), exp( -d * d / twoSigmaRSquared ));
            
%                
%            vec2 L = texture2D(img, uv + vec2(i,j) / img_size).xx;
%
%            norm += 2.0 * kernel;
%            sum += kernel * L;
%        }
%    }
%    sum /= norm;

%    float H = 100.0 * (sum.x - tau * sum.y);
%    float edge = ( H > 0.0 )? 1.0 : 2.0 * smoothstep(-2.0, 2.0, phi * H );
%    gl_FragColor = vec4(vec3(edge), 1.0);