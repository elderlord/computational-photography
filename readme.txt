This is a project use matlab.
src put source code about matlab.
res put resource data about this resource.

1.simplyCopy(fileName, origin[x, y], windowSize(x, y), desSize(x ,y));
2.result ssd(origin, overlap);	主要是用來計算origin與overlap間每個pixel的每個顏色的sum of square difference
3.result mini_cut(input_texture, dir);	計算要input_texture要cut的路徑其中dir用來區分是cut水平或垂直
4.result = image_quilt(input, tile_size, n, overlap, err, simple, useconv); 實作Efros/Freeman Image quilting演算法