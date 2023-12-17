function plot_matching_features(img1, img2, x1, x2, selected_idx)

if nargin<5
    selected_idx=(1:length(x1));
end

x1 = project_to_flat_representation(x1);
x2 = project_to_flat_representation(x2);

imagesc([img1 img2]);
hold on;
plot([x1(1,selected_idx); x2(1,selected_idx)+ size(img1 ,2)], ...
     [x1(2,selected_idx); x2(2,selected_idx)], '-');
hold off;

end

