function [selected_indices, center, threshold_distance] = remove_off_centered_points(Xs, percentile, m, center)

assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");
if (size(Xs, 1)==4)
    Xs = project_to_flat_representation(Xs);
end

if nargin<4
    center = mean(Xs, 2);
end
if nargin<3
    m = 5;
end
if nargin<2
    percentile = 0.9;
end

assert(percentile<=1 & percentile>=0, "percentile must be  in range 0 to 1!");
assert(m>0, "m must be positive!");

distances = sqrt(sum((Xs - center).^2));
sorted_distances = sort(distances);
threshold_distance = m * sorted_distances(floor(length(distances)*percentile));

selected_indices = (distances<threshold_distance);

end

