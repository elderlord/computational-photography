%function result = image_quilt(input, tile_size, n, overlap, err, simple, useconv)
%對input實作 Efros/Freeman Image quilting演算法
%
%Inputs
%   input:  要用來生成的來源圖檔
%   tile_size:   每區塊的大小
%   n:  要重複放置多少塊
%   overlap: 重疊部分要幾個pixel (def: 1/6 tile_size)
%   err: 用來計算每塊最大的誤差值 (def: 0.1)
%   simple: 是否簡單做 1->只是copy每個title, 0->有作cut的動作
%   useconv: 較複雜的運算 1->只計算左邊跟上面重疊部分計算distance, 0->對所有部分再計算一次distance

function result = image_quilt(input, tile_size, n, overlap, err, simple, useconv)

input = double(input);

if( length(size(input)) == 2 )
    input = repmat(input, [1 1 3]);
elseif( length(size(input)) ~= 3 )
    error('Input image must be 2 or 3 dimensional');
end;

if(nargin < 2)
    %沒有設tile_size時把tile_size設定為x,y最小者的一半(因為還要把overlap去除掉)
    if(size(input, 1) < size(input, 2))
        tile_size = size(input, 1) / 2;
    else
        tile_size = size(input, 2) / 2;
    end
else
    %若title_size 大於input的size會有問題所以把他調整最大為input的size的一半
    if(tile_size > size(input, 1))
        tile_size = size(input, 1) / 2;
    end

    if(tile_size > size(input, 2))
        tile_size = size(input, 2) / 2;
    end
end

if( nargin < 3)
   %如果沒有設定重複幾塊的話預設為2塊
   n = 2;
end
if( nargin < 4 )
    overlap = round(tile_size / 6);
end;

if( nargin < 5 )
    err = 0.002;
end;

if(nargin < 6)
    simple = 0;
end

if(nargin < 7)
    useconv = 1;
end

if( overlap >= tile_size )
    error('Overlap must be less than tile_size');
end;

%計算最終的size
destsize = n * tile_size - (n-1) * overlap 

result = zeros(destsize, destsize, 3);

%x方向生成n塊, y方向也生成n塊
for i=1:n,
     for j=1:n,
         startI = (i-1)*tile_size - (i-1) * overlap + 1;
         startJ = (j-1)*tile_size - (j-1) * overlap + 1;
         endI = startI + tile_size -1 ;
         endJ = startJ + tile_size -1;
         
         %計算每個tile跟重疊區域的distance
         %這最後會被convolutions取代
         distances = zeros( size(input,1)-tile_size, size(input,2)-tile_size );
        
        if( useconv == 0 )
            %計算暫存所有pixel的distances
            for a = 1:size(distances,1)
                v1 = result(startI:endI, startJ:endJ, 1:3);
                for b = 1:size(distances,2),                 
                    v2 = input(a:a+tile_size-1,b:b+tile_size-1, 1:3);
                    distances(a,b) = sum_square( double((v1(:) > 0)) .* (v1(:) - v2(:)) ); 
                end;
            end;
            
        else
            %計算剩下區域pixel的distances
            %計算來源以及左邊要重疊區域的distances
            if( j > 1 )
                distances = ssd( input, result(startI:endI, startJ:startJ+overlap-1, 1:3) );    
                distances = distances(1:end, 1:end-tile_size+overlap);
            end;
            
            %計算來源以及上面要重疊區域的distances
            if( i > 1 )
                Z = ssd( input, result(startI:startI+overlap-1, startJ:endJ, 1:3) );
                Z = Z(1:end-tile_size+overlap, 1:end);
                if( j > 1 ) distances = distances + Z;
                else distances = Z;
                end;
            end;
            
            %如果上方以及左邊都需要計算則再計算重疊部分的distance
            if( i > 1 && j > 1 )
                Z = ssd( input, result(startI:startI+overlap-1, startJ:startJ+overlap-1, 1:3) );
                Z = Z(1:end-tile_size+overlap, 1:end-tile_size+overlap);                   
                distances = distances - Z;
            end;
            
        end;

         %找一個最合適的
         best = min(distances(:));
         candidates = find(distances(:) <= (1+err)*best);
          
         idx = candidates(ceil(rand(1)*length(candidates)));
                         
         [sub(1), sub(2)] = ind2sub(size(distances), idx);
         fprintf( 'Picked tile (%d, %d) out of %d candidates.  Best error=%.4f\n', sub(1), sub(2), length(candidates), best );       
         
         alpha=0.5;
         %如果simple是1的話就只是複製tile,不然要做minimum error boundary cut
         if( simple )
              if( i == 1 && j == 1 )
                 result(startI:endI, startJ:endJ, 1:3) = input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
             end
              if j>1
                 
                   result(startI:endI, startJ:startJ+overlap-1,1:3)=(1-alpha)*result(startI:endI, startJ:startJ+overlap-1,1:3)+alpha*input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+overlap-1,1:3);
                   result(startI:endI, startJ+overlap:endJ,1:3)=input(sub(1):sub(1)+tile_size-1, sub(2)+overlap:sub(2)+tile_size-1, 1:3);
              end
              if i>1
                   result(startI:startI+overlap-1, startJ:endJ,1:3)=(1-alpha)* result(startI:startI+overlap-1, startJ:endJ,1:3)+alpha*input(sub(1):sub(1)+overlap-1, sub(2):sub(2)+tile_size-1,1:3);
                   result(startI+overlap:endI, startJ:endJ,1:3)=input(sub(1)+overlap:sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
               end                  
         else
             
             %初始化一個tile_size * tile_size的mask
             mask = ones(tile_size, tile_size);
             
             %計算左邊的overlap
             if( j > 1 )
                 
                 %計算邊界區域的SSD.
                 edge = ( input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+overlap-1) - result(startI:endI, startJ:startJ+overlap-1) ).^2;
                 
                 %計算經過minimum error boundary cut的陣列
                 cost = mini_cut(edge, 0);
                 
                 %計算遮罩並寫到目的資料中
                 mask(1:end, 1:overlap) = double(cost >= 0);
             end;
             
             %計算上面的overlap
             if( i > 1 )
                 %計算邊界區域的SSD.
                 edge = ( input(sub(1):sub(1)+overlap-1, sub(2):sub(2)+tile_size-1) - result(startI:startI+overlap-1, startJ:endJ) ).^2;
                 
                 %計算經過minimum error boundary cut的陣列
                 cost = mini_cut(edge, 1);
                 
                 %計算遮罩並寫到目的資料中
                 mask(1:overlap, 1:end) = mask(1:overlap, 1:end) .* double(cost >= 0);
             end;
             
             
             if( i == 1 && j == 1 )
                 result(startI:endI, startJ:endJ, 1:3) = input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, 1:3);
             else
                 %寫到目的資料中
                 result(startI:endI, startJ:endJ, :) = filtered_write(result(startI:endI, startJ:endJ, :), ...
                     input(sub(1):sub(1)+tile_size-1, sub(2):sub(2)+tile_size-1, :), mask); 
             end;
             
         end;

         image(uint8(result));
         drawnow;
     end;
end;

figure;
image(uint8(result));

function result = sum_square( input )
result = sum( input.^2 );

function A = filtered_write(A, B, mask)
for i = 1:3,
    A(:, :, i) = A(:,:,i) .* (mask == 0) + B(:,:,i) .* (mask == 1);
end;
