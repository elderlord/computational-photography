function main( )
%main 簡單執行的函式
%   image_name: 圖片檔案名稱, 放在res資料夾內
%   tile_size: 區塊大小, 不能超過原始資料大小, 還要注意overlap的大小
%   tile_number: x, y重複幾塊
%   overlap: 重疊的部分要幾個pixel, 不能大於tile_size也不能太小
%   error: 計算是否相符的誤差值
%   simple: 是否簡單做 1->僅是把每個tile複製一塊, 0->複製後再做minimum error boundary cut
%   useconv: 是否考慮其他pixel的相關性 1->僅考慮上方及左方的重地區域, 0->考慮所有pixel的distances
    dir = '../res/';
    file_type = '.jpg';
    image_name = 'Nc13';
    file_name = [dir image_name file_type];
    result_name = [dir image_name '_result' file_type];
    picture = imread(file_name);
    tile_size = 100;
    tile_number = 4;
    overlap = 10;
    error = 0.01;
    simple = 0;
    useconv = 1;
    
    result = image_quilt(picture, tile_size, tile_number, overlap, error, simple, useconv);
    imwrite(uint8(result), result_name);
end

