function [] = visualize_3D_points(arr, linespec, width)

if nargin<2
    linespec = '.';
end
if nargin<3
    width = 10;
end

if numel(arr)~=0
    if (numel(size(arr))==1)
        scatter3(arr(1), arr(2), arr(3), width, linespec);
    else
        scatter3(arr(1,:), arr(2,:), arr(3,:), width, linespec);
    end
end

