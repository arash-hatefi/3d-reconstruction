function [is_degenerate_, H, errors] = check_for_degeneracy(x1s, x2s, threshold)

if nargin<3
    threshold = 1e-10;
end

assert(size(x1s,1)==2 | size(x1s,1)==3, "Wrong x1s shape!");
assert(size(x2s,1)==2 | size(x2s,1)==3, "Wrong x2s shape!");
assert(isequal(size(x1s), size(x2s)), "Size of x1s and x2s must be equal!");
assert(size(x2s,2)==8, "8 points are required!");
assert(threshold>=0, "Threshold cannot be nagative");

if (size(x1s, 1)==2)
    x1s = [x1s; ones(1, length(x1s))];
end
if (size(x2s, 1)==2)
    x2s = [x2s; ones(1, length(x2s))];
end
x1s = project_to_flat_representation(x1s);
x2s = project_to_flat_representation(x2s);

index_sets = [[2, 3, 5, 6]; [2, 6, 7, 8]; [3, 5, 7, 8]; [2, 3, 5, 7]; [1, 3, 5, 7];
              [1, 2, 5, 8]; [1, 2, 3, 4]; [2, 4, 5, 7]; [1, 3, 7, 8]; [4, 5, 7, 8];
              [1, 2, 6, 7]; [4, 6, 7, 8]; [1, 2, 6, 8]; [1, 4, 6, 7]; [1, 2, 4, 8];
              [2, 3, 4, 5]; [1, 5, 6, 8]; [1, 3, 4, 5]; [1, 3, 6, 8]; [2, 4, 5, 6];
              [3, 4, 6, 7]; [4, 5, 6, 8]; [2, 3, 6, 8]; [3, 4, 7, 8]];

is_degenerate_ = false;
errors = 0;
for i=1:length(index_sets)
    index_set = index_sets(i,:);
    H = calculate_homography_matrix(x1s(:, index_set), x2s(:, index_set));
    if numel(H)
        errors = sqrt(sum((project_to_flat_representation(H*x1s)-x2s).^2));
        if sum(errors<threshold)>=5
            is_degenerate_ = true;
            break
        end
    end
end

end

