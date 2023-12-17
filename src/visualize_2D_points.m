function [] = visualize_2D_points(arr, linespec, width)

if nargin<2
    linespec = '.';
end
if nargin<3
    width = 10;
end
    scatter(arr(1,:), arr(2,:), width, linespec);
end

