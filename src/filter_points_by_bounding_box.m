function selected_indices = filter_points_by_bounding_box(Xs, bounding_box)

assert(size(Xs,1)==3 | size(Xs,1)==4, "Wrong Xs shape!");

if (size(Xs, 1)==4)
    Xs = project_to_flat_representation(Xs);
    Xs = Xs(1:3,:);
end

tmp1 = (Xs(1, :)>=bounding_box.x_min);
tmp2 = (Xs(1, :)<=bounding_box.x_max);
tmp3 = (Xs(2, :)>=bounding_box.y_min);
tmp4 = (Xs(2, :)<=bounding_box.y_max);
tmp5 = (Xs(3, :)>=bounding_box.z_min);
tmp6 = (Xs(3, :)<=bounding_box.z_max);

selected_indices = tmp1 & tmp2 & tmp3 & tmp4 & tmp5 & tmp6;

end

