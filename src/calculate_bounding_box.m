function bounding_box = calculate_bounding_box(Xs, margin)

if nargin<2
    margin = 0.1;
end

assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");
assert(margin>=0, "Margin must be non-negative!");

if (size(Xs, 1)==4)
    Xs = project_to_flat_representation(Xs);
    Xs = Xs(1:3,:);
end

bounding_box.x_min = min(Xs(1,:)) - margin;
bounding_box.x_max = max(Xs(1,:)) + margin;
bounding_box.y_min = min(Xs(2,:)) - margin;
bounding_box.y_max = max(Xs(2,:)) + margin;
bounding_box.z_min = min(Xs(3,:)) - margin;
bounding_box.z_max = max(Xs(3,:)) + margin;

end

