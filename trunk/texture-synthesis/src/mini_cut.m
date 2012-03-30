%function result_texture = mini_cut( input_text, dir )
%是實做minimum error boundary cut的步驟
%   output:
%       result_texture是計算cut邊緣後的texture結果
%
%   input:
%       input_text:要計算如何切的texture
%       dir:是要切的方向 0 = 垂直, 1 = 水平
function result_texture = mini_cut( input_text, dir )
%nargin依據輸入的參數來做事,
%在這裡如果dir大於或等於1就代表是水平因此要做矩陣轉換
if( nargin > 1 && dir == 1 )
    input_text = input_text';
end;

%產生一個計算cost paths的陣列,並把第一個row複製到cost paths中
cost_path = zeros(size(input_text));
cost_path(1:end,:) = input_text(1:end,:);

%由第二個陣列開始計算 cost paths直到結束
for i=2:size(cost_path,1),
    
    cost_path(i,1) = input_text(i,1) + min( cost_path(i-1,1), cost_path(i-1,2) );
    for j=2:size(cost_path,2)-1,
        cost_path(i,j) = input_text(i,j) + min( [cost_path(i-1,j-1), cost_path(i-1,j), cost_path(i-1,j+1)] );
    end;
    cost_path(i,end) = input_text(i,end) + min( cost_path(i-1,end-1), cost_path(i-1,end) );
    
end;

%找到切的軌跡
result_texture = zeros(size(input_text));

[cost, idx] = min(cost_path(end, 1:end));
result_texture(i, 1:idx-1) = -1;
result_texture(i, idx) = 0;
result_texture(i, idx+1:end) = +1;  

%       idx-1: left (or top) side of cut
%       idx: along the cut
%       idx+1: right (or bottom) side of cut
for i=size(cost_path,1)-1:-1:1,
    for j=1:size(cost_path,2),

        if( idx > 1 && cost_path(i,idx-1) == min(cost_path(i,idx-1:min(idx+1,size(cost_path,2))) ) )
            idx = idx-1;
        elseif( idx < size(cost_path,2) && cost_path(i,idx+1) == min(cost_path(i,max(idx-1,1):idx+1)) )
            idx = idx+1;
        end;
               
        
        result_texture(i, 1:idx-1) = -1;
        result_texture(i, idx) = 0;
        result_texture(i, idx+1:end) = +1;        
            
    end;
end;
    
if( nargin > 1 && dir == 1 )
    result_texture = result_texture';
end;

