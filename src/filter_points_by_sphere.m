function inlier = filter_points_by_sphere(Xs, center, radius)

center = center(:);

assert(radius>0, "radius must be positive!");
assert(isequal(size(center), [3,1]) | isequal(size(center), [4,1]), "Wrong center shape!");
assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");

if (size(center, 1)==4)
    center = project_to_flat_representation(center);
    center = center(1:3,:);
end

if (size(Xs, 1)==4)
    Xs = project_to_flat_representation(Xs);
    center = [center; 1];
end

distances = sqrt(sum((Xs-center).^2));
inlier = (distances<radius);

end

