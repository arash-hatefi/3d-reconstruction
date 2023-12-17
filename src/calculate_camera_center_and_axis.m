function [center, axis] = calculate_camera_center_and_axis(camera_matrix)

center = null(camera_matrix);
center = center ./ center(4);
center = center(1:3);

axis = camera_matrix(3,1:3)';
axis = axis / norm(axis);
axis = axis(:);

end 
